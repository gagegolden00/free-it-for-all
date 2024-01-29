import { Construct } from "constructs";
import { Fn, TerraformVariable } from "cdktf";

import { CloudwatchLogGroup } from "@cdktf/provider-aws/lib/cloudwatch-log-group";
import { DataAwsCallerIdentity } from "@cdktf/provider-aws/lib/data-aws-caller-identity";
import { EcrRepository } from "@cdktf/provider-aws/lib/ecr-repository";
import { EcsCluster } from "@cdktf/provider-aws/lib/ecs-cluster";
import { EcsClusterCapacityProviders } from "@cdktf/provider-aws/lib/ecs-cluster-capacity-providers";
import { EcsService } from "@cdktf/provider-aws/lib/ecs-service";
import { EcsTaskDefinition } from "@cdktf/provider-aws/lib/ecs-task-definition";
import { ElasticacheCluster } from "@cdktf/provider-aws/lib/elasticache-cluster";
import { IamGroup } from "@cdktf/provider-aws/lib/iam-group";
import { IamPolicy } from "@cdktf/provider-aws/lib/iam-policy";
import { IamPolicyAttachment } from "@cdktf/provider-aws/lib/iam-policy-attachment";
import { IamRole } from "@cdktf/provider-aws/lib/iam-role";
import { IamRolePolicyAttachment } from "@cdktf/provider-aws/lib/iam-role-policy-attachment";
import { LbTargetGroup } from "@cdktf/provider-aws/lib/lb-target-group";
import { S3Bucket } from "@cdktf/provider-aws/lib/s3-bucket";
import { SecurityGroup } from "@cdktf/provider-aws/lib/security-group";

import { Rds } from "../.gen/modules/terraform-aws-modules/aws/rds";
import { Vpc } from "../.gen/modules/terraform-aws-modules/aws/vpc";

export class EcrConstruct extends Construct {
  repo: EcrRepository;

  constructor(
    scope: Construct,
    id: string,
    organization: string,
  ) {
    super(scope, `${id}-ecr-`);

    this.repo = new EcrRepository(this, `${id}-ecr-repo`, {
      name: `${organization}/${id}`,
    });

    const ecrAccessGroup = new IamGroup(this, `${id}-ecr-access`, {
      name: `${id}-ecr-access`,
    });

    this.grantPushPolicy(id, this.repo, ecrAccessGroup);
  }

  grantPushPolicy(id: string, repo: EcrRepository, ecrAccessGroup: IamGroup) {
    const ecrPushPolicy = new IamPolicy(this, `${id}-identity-policy-ecr-push`, {
      name: `${id}-ecr-push`,
      policy: JSON.stringify({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": ["ecr:GetAuthorizationToken"],
            "Resource": ["*"],
          },
          {
            "Effect": "Allow",
            "Action": ["ecr:PutImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload", "ecr:BatchCheckLayerAvailability"],
            "Resource": [repo.arn],
          }
        ]
      }),
    });

    new IamPolicyAttachment(this, `${id}-identity-policy-attachment-ecr-push`, {
      name: `${id}-ecr-push`,
      policyArn: ecrPushPolicy.arn,
      groups: [ecrAccessGroup.name],
    });
  }
}

export class EcsConstruct extends Construct {
  constructor(
    scope: Construct,
    id: string,
    organization: string,
    environment: string,
    region: string,
    vpc: Vpc,
    postgres: Rds,
    redis: ElasticacheCluster,
    s3Bucket: S3Bucket,
    repo: EcrRepository,
    lbTargetGroup: LbTargetGroup,
    serviceSecurityGroup: SecurityGroup,
  ) {
    super(scope, `${id}-ecs-`);

    const cluster = new EcsCluster(this, `${id}-ecs-cluster`, {
      name: id,
    });

    new EcsClusterCapacityProviders(this, `${id}-ecs-cluster-capacity-providers`, {
      clusterName: cluster.name,
      capacityProviders: ["FARGATE"],
    });

    const assumeRolePolicy = JSON.stringify({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    });

    const executionRole = new IamRole(this, `${id}-ecs-task-execution-role`, {
      name: `${id}-ecs-task-execution-role`,
      assumeRolePolicy,
    });

    new IamRolePolicyAttachment(this, `${id}-ecs-task-execution-role-policy-attachment`, {
      role: executionRole.name,
      policyArn: "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    });

    const taskRole = new IamRole(this, `${id}-ecs-task-role`, {
      name: `${id}-ecs-task-role`,
      assumeRolePolicy,
      inlinePolicy: [
        {
          name: "allow-ssm",
          policy: JSON.stringify({
            Version: "2012-10-17",
            Statement: [
              {
                Effect: "Allow",
                Action: [
                  "ssmmessages:CreateControlChannel",
                  "ssmmessages:CreateDataChannel",
                  "ssmmessages:OpenControlChannel",
                  "ssmmessages:OpenDataChannel"
                ],
                Resource: "*",
              },
            ],
          }),
        },
        {
          name: "allow-s3",
          policy: JSON.stringify({
            Version: "2012-10-17",
            Statement: [
              {
                Effect: "Allow",
                Action: [
                  "s3:PutObject",
                  "s3:GetObject",
                  "s3:DeleteObject",
                  "s3:ListBucket",
                ],
                Resource: [
                  s3Bucket.arn,
                  `${s3Bucket.arn}/*`,
                ],
              },
            ],
          }),
        },
      ],
    });

    const logGroup = new CloudwatchLogGroup(this, `${id}-ecs-cloudwatch-log-group`, {
      name: id,
      retentionInDays: 30,
    });

    const postgresUrl = `postgresql://${postgres.username}:${postgres.password}@${postgres.dbInstanceAddressOutput}:${postgres.port}/${organization}_${environment}`;
    const redisUrl = `redis://${redis.cacheNodes.get(0).address}:${redis.cacheNodes.get(0).port}/0`;
    const railsMasterKey = new TerraformVariable(scope, "RAILS_MASTER_KEY", {}).value.toString();

    const webTaskDefinition = new EcsTaskDefinition(this, `${id}-ecs-web-task-definition`, {
      family: `${id}-web`,
      networkMode: "awsvpc",
      cpu: "1024",
      memory: "2048",
      executionRoleArn: executionRole.arn,
      taskRoleArn: taskRole.arn,
      containerDefinitions: JSON.stringify(
      [
        {
          name: "container",
          image: `${repo.repositoryUrl}:release`,
          portMappings: [
            {
              containerPort: "3000",
              protocol: "tcp",
            },
          ],
          environment: [
            { name: "RAILS_ENV", value: environment },
            { name: "DATABASE_URL", value: postgresUrl },
            { name: "REDIS_URL", value: redisUrl },
            { name: "RAILS_MASTER_KEY", value: railsMasterKey },
            { name: "RAILS_SERVE_STATIC_FILES", value: "true" },
            { name: "RAILS_LOG_TO_STDOUT", value: "true" },
          ],
          logConfiguration: {
            logDriver: "awslogs",
            options: {
              "awslogs-group": logGroup.name,
              "awslogs-region": region,
              "awslogs-stream-prefix": "ecs-web",
            },
          },
        },
      ]),
    });

    new EcsService(this, `${id}-ecs-web-service`, {
      name: "web",
      launchType: "FARGATE",
      cluster: cluster.id,
      desiredCount: 1,
      taskDefinition: webTaskDefinition.arn,
      enableExecuteCommand: true,
      networkConfiguration: {
        subnets: Fn.tolist(vpc.publicSubnetsOutput),
        assignPublicIp: true,
        securityGroups: [serviceSecurityGroup.id],
      },
      loadBalancer: [
        {
          containerPort: 3000,
          containerName: "container",
          targetGroupArn: lbTargetGroup.arn,
        },
      ],
      lifecycle: {
        createBeforeDestroy: true,
      },
    });

    const jobTaskDefinition = new EcsTaskDefinition(this, `${id}-ecs-job-task-definition`, {
      family: `${id}-job`,
      networkMode: "awsvpc",
      cpu: "512",
      memory: "1024",
      executionRoleArn: executionRole.arn,
      taskRoleArn: taskRole.arn,
      containerDefinitions: JSON.stringify(
      [
        {
          name: "container",
          image: `${repo.repositoryUrl}:release`,
          command: ["sidekiq"],
          environment: [
            { name: "RAILS_ENV", value: environment },
            { name: "DATABASE_URL", value: postgresUrl },
            { name: "REDIS_URL", value: redisUrl },
            { name: "RAILS_MASTER_KEY", value: railsMasterKey },
            { name: "RAILS_LOG_TO_STDOUT", value: "true" },
          ],
          logConfiguration: {
            logDriver: "awslogs",
            options: {
              "awslogs-group": logGroup.name,
              "awslogs-region": region,
              "awslogs-stream-prefix": "ecs-job",
            },
          },
        },
      ]),
    });

    new EcsService(this, `${id}-ecs-job-service`, {
      name: "job",
      launchType: "FARGATE",
      cluster: cluster.id,
      desiredCount: 1,
      taskDefinition: jobTaskDefinition.arn,
      enableExecuteCommand: true,
      networkConfiguration: {
        subnets: Fn.tolist(vpc.publicSubnetsOutput),
        assignPublicIp: true,
        securityGroups: [serviceSecurityGroup.id],
      },
      lifecycle: {
        createBeforeDestroy: true,
      },
    });

    const migrateTaskDefinition = new EcsTaskDefinition(this, `${id}-ecs-migrate-task-definition`, {
      family: `${id}-migrate`,
      networkMode: "awsvpc",
      cpu: "256",
      memory: "512",
      executionRoleArn: executionRole.arn,
      taskRoleArn: taskRole.arn,
      containerDefinitions: JSON.stringify(
      [
        {
          name: "container",
          image: `${repo.repositoryUrl}:release`,
          command: ["rails", "db:migrate"],
          environment: [
            { name: "RAILS_ENV", value: environment },
            { name: "DATABASE_URL", value: postgresUrl },
            { name: "REDIS_URL", value: redisUrl },
            { name: "RAILS_MASTER_KEY", value: railsMasterKey },
            { name: "RAILS_LOG_TO_STDOUT", value: "true" },
          ],
          logConfiguration: {
            logDriver: "awslogs",
            options: {
              "awslogs-group": logGroup.name,
              "awslogs-region": region,
              "awslogs-stream-prefix": "ecs-migrate",
            },
          },
        },
      ]),
    });

    const taskAccessGroup = new IamGroup(this, `${id}-ecs-task-access`, {
      name: `${id}-ecs-task-access`,
    });

    const serviceAccessGroup = new IamGroup(this, `${id}-ecs-service-access`, {
      name: `${id}-ecs-service-access`,
    });

    const accountId = new DataAwsCallerIdentity(this, `${id}-caller-identity`, {}).accountId;

    this.grantRunTaskPolicy(id, region, accountId, cluster, executionRole, taskRole, [webTaskDefinition, jobTaskDefinition, migrateTaskDefinition], taskAccessGroup);
    this.grantExecuteCommandPolicy(id, region, accountId, cluster, taskAccessGroup);
    this.grantUpdateServicePolicy(id, region, accountId, cluster, serviceAccessGroup);
  }

  grantRunTaskPolicy(id: string, region: string, accountId: string, cluster: EcsCluster, executionRole: IamRole, taskRole: IamRole, taskDefinitions: EcsTaskDefinition[], taskAccessGroup: IamGroup) {
    const runTaskPolicy = new IamPolicy(this, `${id}-identity-policy-run-task`, {
      name: `${id}-run-task`,
      policy: JSON.stringify({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": ["ecs:ListTaskDefinitions"],
            "Resource": ["*"]
          },
          {
            "Effect": "Allow",
            "Action": ["ec2:DescribeSubnets"],
            "Resource": ["*"]
          },
          {
            "Effect": "Allow",
            "Action": ["ec2:DescribeSecurityGroups"],
            "Resource": ["*"]
          },
          {
            "Effect": "Allow",
            "Action": ["iam:PassRole"],
            "Resource": [executionRole.arn, taskRole.arn]
          },
          {
            "Effect": "Allow",
            "Action": ["ecs:RunTask"],
            "Resource": taskDefinitions.map(taskDefinition => `arn:aws:ecs:${region}:${accountId}:task-definition/${taskDefinition.family}:*`),
            "Condition": {
              "ArnEquals": {
                "ecs:cluster": cluster.arn,
              }
            },
          }
        ]
      }),
    });

     new IamPolicyAttachment(this, `${id}-identity-policy-attachment-run-task`, {
      name: `${id}-run-task`,
      policyArn: runTaskPolicy.arn,
      groups: [taskAccessGroup.name],
    });
  }

  grantExecuteCommandPolicy(id: string, region: string, accountId: string, cluster: EcsCluster, taskAccessGroup: IamGroup) {
    const executeCommandPolicy = new IamPolicy(this, `${id}-identity-policy-execute-command`, {
      name: `${id}-execute-command`,
      policy: JSON.stringify({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": ["ecs:ListTasks"],
            "Resource": ["*"]
          },
          {
            "Effect": "Allow",
            "Action": ["ecs:DescribeTasks"],
            "Resource": ["*"]
          },
          {
            "Effect": "Allow",
            "Action": ["ecs:ExecuteCommand"],
            "Resource": [cluster.arn, `arn:aws:ecs:${region}:${accountId}:task/${cluster.name}/*`],
          }
        ]
      }),
    });

    new IamPolicyAttachment(this, `${id}-identity-policy-attachment-execute-command`, {
      name: `${id}-execute-command`,
      policyArn: executeCommandPolicy.arn,
      groups: [taskAccessGroup.name],
    });
  }

  grantUpdateServicePolicy(id: string, region: string, accountId: string, cluster: EcsCluster, serviceAccessGroup: IamGroup) {
    const updateServicePolicy = new IamPolicy(this, `${id}-identity-policy-update-service`, {
      name: `${id}-update-service`,
      policy: JSON.stringify({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": ["ecs:UpdateService"],
            "Resource": [`arn:aws:ecs:${region}:${accountId}:service/${cluster.name}/*`],
          }
        ]
      }),
    });

    new IamPolicyAttachment(this, `${id}-identity-policy-attachment-update-service`, {
      name: `${id}-update-service`,
      policyArn: updateServicePolicy.arn,
      groups: [serviceAccessGroup.name],
    });
  }
}
