import { Construct } from "constructs";

import { AcmCertificate } from "@cdktf/provider-aws/lib/acm-certificate";
import { AcmCertificateValidation } from "@cdktf/provider-aws/lib/acm-certificate-validation";
import { CloudfrontCachePolicy } from "@cdktf/provider-aws/lib/cloudfront-cache-policy";
import { CloudfrontDistribution } from "@cdktf/provider-aws/lib/cloudfront-distribution";
import { Lb } from "@cdktf/provider-aws/lib/lb";

export class CloudfrontConstruct extends Construct {
  constructor(
    scope: Construct,
    id: string,
    region: string,
    domainName: string,
    loadBalancer: Lb,
    sslCertificate: AcmCertificate,
    sslCertificateValidation: AcmCertificateValidation,
  ) {
    super(scope, `${id}-cloudfront-`);

    const cachePolicy = new CloudfrontCachePolicy(this, `${id}-cloudfront-cache-policy`, {
      name: `${id}-cache-policy`,
      defaultTtl: 0,
      maxTtl: 31536000,
      minTtl: 0,
      parametersInCacheKeyAndForwardedToOrigin: {
        headersConfig: {
          headerBehavior: "none",
        },
        cookiesConfig: {
          cookieBehavior: "none",
        },
        queryStringsConfig: {
          queryStringBehavior: "all",
        },
        enableAcceptEncodingBrotli: true,
        enableAcceptEncodingGzip: true,
      },
    });

    new CloudfrontDistribution(this, `${id}-cloudfront`, {
      dependsOn: [sslCertificateValidation],
      comment: id,
      enabled: true,
      isIpv6Enabled: true,
      aliases: [domainName, `www.${domainName}`],
      origin: [
        {
          domainName: loadBalancer.dnsName,
          originId: loadBalancer.arn,
          customOriginConfig: {
            originProtocolPolicy: "http-only",
            httpPort: 80,
            httpsPort: 443,
            originSslProtocols: ["TLSv1.2"],
          },
          customHeader: [
            {
              name: "X-Forwarded-Port",
              value: "443",
            },
            {
              name: "X-Forwarded-Ssl",
              value: "on",
            },
            {
              name: "X-Cloudfront-Key",
              value: "287c83f55e72d32b35bd372f32d6cda975b8",
            },
          ],
          originShield: {
            enabled: true,
            originShieldRegion: region,
          },
        }
      ],
      defaultCacheBehavior: {
        allowedMethods: ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"],
        cachedMethods: ["GET", "HEAD"],
        targetOriginId: loadBalancer.arn,
        viewerProtocolPolicy: "redirect-to-https",
        compress: true,
        cachePolicyId: cachePolicy.id,
        originRequestPolicyId: "216adef6-5c7f-47e4-b989-5492eafa07d3",
        responseHeadersPolicyId: "67f7725c-6f97-4210-82d7-5512b31e9d03",
      },
      restrictions: {
        geoRestriction: {
          restrictionType: "none",
        },
      },
      viewerCertificate: {
        acmCertificateArn: sslCertificate.arn,
        minimumProtocolVersion: "TLSv1.2_2021",
        sslSupportMethod: "sni-only",
      },
    });
  }
}
