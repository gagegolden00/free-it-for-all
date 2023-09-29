import { Construct } from "constructs";

import { ElasticacheCluster } from "@cdktf/provider-aws/lib/elasticache-cluster";
import { ElasticacheSubnetGroup } from "@cdktf/provider-aws/lib/elasticache-subnet-group";
import { SecurityGroup } from "@cdktf/provider-aws/lib/security-group";
import { Password } from "@cdktf/provider-random/lib/password";

import { Rds } from "../.gen/modules/terraform-aws-modules/aws/rds";
import { Vpc } from "../.gen/modules/terraform-aws-modules/aws/vpc";

export class PostgresConstruct extends Construct {
  postgres: Rds;

  constructor(
    scope: Construct,
    id: string,
    vpc: Vpc,
    postgresSecurityGroup: SecurityGroup,
  ) {
    super(scope, `${id}-postgres-`);

    const password = new Password(this, `${id}-postgres-password`, {
      length: 16,
      special: false,
    });

    this.postgres = new Rds(this, `${id}-postgres`, {
      identifier: id,
      engine: "postgres",
      engineVersion: "15.3",
      family: "postgres15",
      majorEngineVersion: "15",
      instanceClass: "db.t3.micro",
      allocatedStorage: "20",
      createDbOptionGroup: false,
      createDbParameterGroup: false,
      applyImmediately: true,
      port: "5432",
      username: "postgres",
      password: password.result,
      manageMasterUserPassword: false,
      maintenanceWindow: "Mon:00:00-Mon:03:00",
      backupWindow: "03:00-06:00",
      backupRetentionPeriod: 35,
      dbSubnetGroupName: vpc.databaseSubnetGroupNameOutput,
      subnetIds: vpc.databaseSubnetsOutput as unknown as any,
      vpcSecurityGroupIds: [postgresSecurityGroup.id],
    });
  }
}

export class RedisConstruct extends Construct {
  public redis: ElasticacheCluster;

  constructor(
    scope: Construct,
    id: string,
    vpc: Vpc,
    redisSecurityGroup: SecurityGroup,
  ) {
    super(scope, `${id}-redis-`);

    const subnetGroup = new ElasticacheSubnetGroup(this, `${id}-redis-subnet-group`, {
      name: id,
      subnetIds: vpc.databaseSubnetsOutput as unknown as any,
    });

    this.redis = new ElasticacheCluster(this, `${id}-redis`, {
      clusterId: id,
      engine: "redis",
      nodeType: "cache.t3.micro",
      numCacheNodes: 1,
      subnetGroupName: subnetGroup.name,
      securityGroupIds: [redisSecurityGroup.id],
    });
  }
}
