import { Construct } from "constructs";

import { AcmCertificate } from "@cdktf/provider-aws/lib/acm-certificate";
import { AcmCertificateValidation } from "@cdktf/provider-aws/lib/acm-certificate-validation";
import { SecurityGroup } from "@cdktf/provider-aws/lib/security-group";

import { Vpc } from "../.gen/modules/terraform-aws-modules/aws/vpc";

export class SecurityGroupConstruct extends Construct {
  lbSecurityGroup: SecurityGroup;
  serviceSecurityGroup: SecurityGroup;
  postgresSecurityGroup: SecurityGroup;
  redisSecurityGroup: SecurityGroup;

  constructor(
    scope: Construct,
    id: string,
    vpc: Vpc,
  ) {
    super(scope, `${id}-sg-`);

    this.lbSecurityGroup = new SecurityGroup(this, `${id}-sg-lb`, {
      name: `${id}-lb-2`,
      description: "Allow HTTP traffic from all to ALB",
      vpcId: vpc.vpcIdOutput,
      ingress: [
        {
          protocol: "TCP",
          fromPort: 80,
          toPort: 80,
          cidrBlocks: ["0.0.0.0/0"],
          ipv6CidrBlocks: ["::/0"],
        },
        {
          protocol: "TCP",
          fromPort: 443,
          toPort: 443,
          cidrBlocks: ["0.0.0.0/0"],
          ipv6CidrBlocks: ["::/0"],
        },
      ],
      egress: [
        {
          fromPort: 0,
          toPort: 0,
          protocol: "-1",
          cidrBlocks: ["0.0.0.0/0"],
          ipv6CidrBlocks: ["::/0"],
        },
      ],
      lifecycle: {
        createBeforeDestroy: true,
      },
    });

    this.serviceSecurityGroup = new SecurityGroup(this, `${id}-sg-service`, {
      name: `${id}-ecs-cluster-service-2`,
      description: "Allow HTTP traffic from ALB to ECS Cluster Service",
      vpcId: vpc.vpcIdOutput,
      ingress: [
        {
          protocol: "TCP",
          fromPort: 443,
          toPort: 443,
          securityGroups: [this.lbSecurityGroup.id],
        },
      ],
      egress: [
        {
          fromPort: 0,
          toPort: 0,
          protocol: "-1",
          cidrBlocks: ["0.0.0.0/0"],
          ipv6CidrBlocks: ["::/0"],
        },
      ],
      lifecycle: {
        createBeforeDestroy: true,
      },
    });

    this.postgresSecurityGroup = new SecurityGroup(this, `${id}-sg-postgres`, {
      name: `${id}-postgres-2`,
      description: "Allow Postgres traffic from ECS Cluster Service to Postgres",
      vpcId: vpc.vpcIdOutput,
      ingress: [
        {
          protocol: "TCP",
          fromPort: 5432,
          toPort: 5432,
          securityGroups: [this.serviceSecurityGroup.id],
        },
      ],
      lifecycle: {
        createBeforeDestroy: true,
      },
    });

    this.redisSecurityGroup = new SecurityGroup(this, `${id}-sg-redis`, {
      name: `${id}-redis-2`,
      description: "Allow Redis traffic from ECS Cluster Service to Redis",
      vpcId: vpc.vpcIdOutput,
      ingress: [
        {
          protocol: "TCP",
          fromPort: 6379,
          toPort: 6379,
          securityGroups: [this.serviceSecurityGroup.id],
        },
      ],
      lifecycle: {
        createBeforeDestroy: true,
      },
    });
  }
}

export class SslCertificateConstruct extends Construct {
  sslCertificate: AcmCertificate;
  sslCertificateValidation: AcmCertificateValidation;

  constructor(
    scope: Construct,
    id: string,
    domainName: string,
  ) {
    super(scope, `${id}-ssl-certificate-`);

    this.sslCertificate = new AcmCertificate(this, `${id}-ssl-certificate`, {
      domainName: domainName,
      subjectAlternativeNames: [`*.${domainName}`],
      validationMethod: "DNS",
      lifecycle: {
        createBeforeDestroy: true,
      },
    });

    this.sslCertificateValidation = new AcmCertificateValidation(this, `${id}-ssl-certificate-validation`, {
      certificateArn: this.sslCertificate.arn,
    });
  }
}
