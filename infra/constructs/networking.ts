import { Construct } from "constructs";

import { Vpc } from "../.gen/modules/terraform-aws-modules/aws/vpc";

export class VpcConstruct extends Construct {
  public vpc: Vpc;

  constructor(
    scope: Construct,
    id: string,
    environment: string,
    region: string
  ) {
    super(scope, `${id}-vpc-`);

    let azs: string[];
    let cidr: string;
    let privateSubnets: string[];
    let publicSubnets: string[];
    let databaseSubnets: string[];

    switch (environment) {
      case "production":
        azs = [`${region}a`, `${region}b`];
        cidr = "10.0.0.0/16";
        privateSubnets = ["10.0.1.0/24", "10.0.2.0/24"];
        publicSubnets = ["10.0.101.0/24", "10.0.102.0/24"];
        databaseSubnets = ["10.0.201.0/24", "10.0.202.0/24"];
        break;
      case "staging":
        azs = [`${region}a`, `${region}b`];
        cidr = "10.1.0.0/16";
        privateSubnets = ["10.1.1.0/24", "10.1.2.0/24"];
        publicSubnets = ["10.1.101.0/24", "10.1.102.0/24"];
        databaseSubnets = ["10.1.201.0/24", "10.1.202.0/24"];
        break;
      default:
        throw new Error(`Invalid environment: ${environment}`);
    }

    this.vpc = new Vpc(this, `${id}-vpc`, {
      name: id,
      azs,
      cidr,
      privateSubnets,
      publicSubnets,
      databaseSubnets,
      createDatabaseSubnetGroup: true,
      enableNatGateway: false,
    });
  }
}
