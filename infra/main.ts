import { Construct } from "constructs";
import {
  App,
  TerraformStack,
  CloudBackend,
  NamedCloudWorkspace,
} from "cdktf";

import { AwsProvider } from "@cdktf/provider-aws/lib/provider";
import { RandomProvider } from "@cdktf/provider-random/lib/provider";

import { VpcConstruct } from "./constructs/networking";
import { SecurityGroupConstruct, SslCertificateConstruct } from "./constructs/security";
import { LoadBalancerConstruct } from "./constructs/compute";
import { PostgresConstruct, RedisConstruct } from "./constructs/database";
import { S3Construct } from "./constructs/storage";
import { CloudfrontConstruct } from "./constructs/cloudfront";
import { EcrConstruct, EcsConstruct } from "./constructs/containers";

interface WebAppStackConfig {
  organization: string;
  environment: string;
  region: string;
  domainName: string;
}

class WebAppStack extends TerraformStack {
  constructor(scope: Construct, id: string, config: WebAppStackConfig) {
    super(scope, id);

    const { organization, environment, region, domainName } = config;

    new AwsProvider(this, "AWS", { region });
    new RandomProvider(this, "Random", {});

    const { vpc } = new VpcConstruct(this, id, environment, region);
    const { lbSecurityGroup, postgresSecurityGroup, redisSecurityGroup, serviceSecurityGroup } = new SecurityGroupConstruct(this, id, vpc);
    const { sslCertificate, sslCertificateValidation } = new SslCertificateConstruct(this, id, domainName);
    const { loadBalancer, lbTargetGroup } = new LoadBalancerConstruct(this, id, vpc, lbSecurityGroup);
    const { postgres } = new PostgresConstruct(this, id, vpc, postgresSecurityGroup);
    const { redis } = new RedisConstruct(this, id, vpc, redisSecurityGroup);
    const { s3Bucket } = new S3Construct(this, id, organization);
    const { repo } = new EcrConstruct(this, id, organization);
    const {} = new EcsConstruct(this, id, organization, environment, region, vpc, postgres, redis, s3Bucket, repo, lbTargetGroup, serviceSecurityGroup);
    const {} = new CloudfrontConstruct(this, id, region, domainName, loadBalancer, sslCertificate, sslCertificateValidation);

    // --------------------- Deployment ---------------------

    // CodePipeline
    // CodeBuild
    // CodeDeploy

    // --------------------- Monitoring ---------------------

    // CloudWatch

    // --------------------- Security ---------------------

    // Bastion (Maybe not necessary if we're using ECS Fargate)
    // Guard Duty
    // Inspector
    // Audit Manager
  }
}

const organization = "mech-cool";
const domainNames: { [key: string]: string } = {
  production: "app.mechcool.rubyshore.com",
};

const app = new App();

["production"].forEach((environment) => {
  const stack = new WebAppStack(app, `web-app-${environment}`, {
    organization,
    environment,
    region: "us-east-1",
    domainName: domainNames[environment],
  });
  new CloudBackend(stack, {
    hostname: "app.terraform.io",
    organization,
    workspaces: new NamedCloudWorkspace(`web-app-${environment}`),
  });
});

app.synth();
