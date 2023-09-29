import { Construct } from "constructs";
import { S3Bucket } from "@cdktf/provider-aws/lib/s3-bucket";

export class S3Construct extends Construct {
  s3Bucket: S3Bucket;
  constructor(
    scope: Construct,
    id: string,
    organization: string,
  ) {
    super(scope, `${id}-s3-bucket-`);

    this.s3Bucket = new S3Bucket(this, `${id}-s3-bucket`, {
      bucket: `${organization}-${id}`,
      forceDestroy: true,
    });
  }
}
