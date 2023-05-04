# S3 Terraform Module
[Github Link](https://github.com/RedVentures/terraform-aws-s3)

This repo contains a root module for creating a s3 bucket. The bucket
will be encrypted by default and has a bucket policy that applies [Defense-in-Depth](https://aws.amazon.com/blogs/security/how-to-use-bucket-policies-and-apply-defense-in-depth-to-help-secure-your-amazon-s3-data/)
to prevent the bucket from becomming public.

Standard module usage:

```hcl
module "bucket" {
  source  = "app.terraform.io/RVStandard/s3/aws"
  version = "~> 4.0"

  name        = "rv-my-bucket"
  environment = "${var.workspace}"
  project     = "${var.project_name}"
  partner        = "PartnerName"
  owner          = "email@redventures.com"
  classification = "India"
}
```

Module usage when paired with CloudFront:

```hcl
module "bucket" {
  source  = "app.terraform.io/RVStandard/s3/aws"
  version = "~> 4.0"

  name        = "rv-my-bucket"
  environment = "${var.workspace}"
  project     = "${var.project_name}"
  partner        = "PartnerName"
  owner          = "email@redventures.com"
  classification = "India"

  sse_algorithm = "AES256"
}
```
Input variables you may want to change:

- `kms_key`: By default this uses the default s3 kms key in the account. You can pass in a custom key that you have created, but you should only need to do this if
you need to read and write to the bucket from a different AWS account.
- `enable_versioning`: By default this is set to `false`
- `bucket_policy`: The bucket is provisioned with a default bucket policy, but you can add to the policy by providing this variable. This expects a `data.aws_iam_policy_document.json`

For an example of creating an s3 bucket that will need cross account access, please see [S3 Cross Account Example](https://terraform-docs.cloud.rvapps.io/modules/examples/s3-cross-account-example.html)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/RedVentures/terraform-abstraction/CONTRIBUTING.md) for details around contributing to the project.

### Issues

Issues have been disabled on this project. Please create issues [here](https://github.com/RedVentures/terraform-abstraction/issues/new/choose)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| asset\_tag | This value should be identified via SNOW | string | `"n/a"` | no |
| backup | Automation tag which defines backup schedule to apply | string | `"n/a"` | no |
| bucket\_policy | \(String\) An optional iam policy document statement to append to the default policy. | string | `""` | no |
| classification | Coded data sensitivity \(Romeo, Sierra, India, Lima, Echo; Sensitive; Restricted; Internal; Limited External; External\) | string | n/a | yes |
| enable | \(String\) whether or not to create this module | string | `"true"` | no |
| enable\_versioning | \(String\) Whether or not to enable versioning | string | `"false"` | no |
| environment | \(String\) The environment the bucket belongs to | string | n/a | yes |
| expiration | \(String\) Number of days before objects should expire | string | `""` | no |
| global | \(String\) Set this to true to remove the environment/region suffix from the bucket name | string | `"false"` | no |
| kms\_key | \(String\) The kms key to use for encryption. Uses aws/s3 kms key by default | string | `""` | no |
| name | \(String\) The name of the bucket to create. | string | n/a | yes |
| noncurrent\_version\_expiration | \(String\) Number of days before non-current objects should expire | string | `""` | no |
| owner | Email address of the first-level contact for the resource | string | n/a | yes |
| partner | Business unit for which the resource is deployed \(i.e., AT&T, Verizon, Internal, Shared, etc\) See SNOW for more valid options | string | n/a | yes |
| project | \(String\) The project that the bucket belongs to | string | n/a | yes |
| provisioner | Tool used to provision the resource | string | `"terraform://terraform-aws-s3"` | no |
| resource\_version | Distinguish between different versions of the resource | string | `"n/a"` | no |
| sse\_algorithm | \(String\) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms \[default: aws:kms\] | string | `"aws:kms"` | no |
| tags | \(Map\) Optionally specify additional tags to add to the bucket | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the bucket |
| bucket\_domain\_name | The bucket domain name. This would be used to as the s3 origin in a cloudfront resoruce |
| bucket\_regional\_domain\_name | The bucket region-specific domain name. The bucket domain name including the region name. |
| hosted\_zone\_id | The Route 53 Hosted Zone ID for this bucket's region |
| metadata |  |
| name | The name of the bucket |
| region | The AWS region this bucket resides in |

