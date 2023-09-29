import { Construct } from "constructs";
import { Fn } from "cdktf";

import { Lb } from "@cdktf/provider-aws/lib/lb";
import { LbListener } from "@cdktf/provider-aws/lib/lb-listener";
import { LbListenerRule } from "@cdktf/provider-aws/lib/lb-listener-rule";
import { LbTargetGroup } from "@cdktf/provider-aws/lib/lb-target-group";
import { SecurityGroup } from "@cdktf/provider-aws/lib/security-group";

import { Vpc } from "../.gen/modules/terraform-aws-modules/aws/vpc";

export class LoadBalancerConstruct extends Construct {
  loadBalancer: Lb;
  lbTargetGroup: LbTargetGroup;

  constructor(
    scope: Construct,
    id: string,
    vpc: Vpc,
    lbSecurityGroup: SecurityGroup,
  ) {
    super(scope, `${id}-lb-`);

    this.loadBalancer = new Lb(this, `${id}-lb`, {
      name: id,
      internal: false,
      loadBalancerType: "application",
      securityGroups: [lbSecurityGroup.id],
      subnets: Fn.tolist(vpc.publicSubnetsOutput),
    });

    const lbListenerHttp = new LbListener(this, `${id}-lb-listener`, {
      loadBalancerArn: this.loadBalancer.arn,
      port: 80,
      protocol: "HTTP",
      defaultAction: [
        {
          type: "fixed-response",
          fixedResponse: {
            contentType: "text/plain",
            statusCode: "500",
            messageBody: "Not Allowed",
          },
        },
      ],
    });

    this.lbTargetGroup = new LbTargetGroup(this, `${id}-lb-target-group`, {
      dependsOn: [lbListenerHttp],
      name: id,
      port: 80,
      protocol: "HTTP",
      targetType: "ip",
      vpcId: vpc.vpcIdOutput,
      healthCheck: {
        enabled: true,
        path: "/up",
      },
    });

    new LbListenerRule(this, `${id}-lb-listener-rule`, {
      listenerArn: lbListenerHttp.arn,
      priority: 1,
      action: [
        {
          type: "forward",
          targetGroupArn: this.lbTargetGroup.arn,
        },
      ],
      condition: [
        {
          httpHeader: {
            httpHeaderName: "X-Cloudfront-Key",
            values: ["287c83f55e72d32b35bd372f32d6cda975b8"],
          }
        },
      ],
    });
  }
}
