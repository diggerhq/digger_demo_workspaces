/**
 * # S3 Terraform Module
 * [Github Link](https://github.com/RedVentures/terraform-aws-s3)
 *
 * This repo contains a root module for creating a s3 bucket. The bucket
 * will be encrypted by default and has a bucket policy that applies [Defense-in-Depth](https://aws.amazon.com/blogs/security/how-to-use-bucket-policies-and-apply-defense-in-depth-to-help-secure-your-amazon-s3-data/)
 * to prevent the bucket from becomming public.
 *
 * Standard module usage:
 *
 * ```hcl
 * module "bucket" {
 *   source  = "app.terraform.io/RVStandard/s3/aws"
 *   version = "~> 4.0"
 *
 *   name        = "rv-my-bucket"
 *   environment = "${var.workspace}"
 *   project     = "${var.project_name}"
 *   partner        = "PartnerName"
 *   owner          = "email@redventures.com"
 *   classification = "India"
 * }
 * ```
 *
 * Module usage when paired with CloudFront:
 *
 * ```hcl
 * module "bucket" {
 *   source  = "app.terraform.io/RVStandard/s3/aws"
 *   version = "~> 4.0"
 *
 *   name        = "rv-my-bucket"
 *   environment = "${var.workspace}"
 *   project     = "${var.project_name}"
 *   partner        = "PartnerName"
 *   owner          = "email@redventures.com"
 *   classification = "India"
 *
 *   sse_algorithm = "AES256"
 * }
 * ```
 * Input variables you may want to change:
 *
 * - `kms_key`: By default this uses the default s3 kms key in the account. You can pass in a custom key that you have created, but you should only need to do this if
 * you need to read and write to the bucket from a different AWS account.
 * - `enable_versioning`: By default this is set to `false`
 * - `bucket_policy`: The bucket is provisioned with a default bucket policy, but you can add to the policy by providing this variable. This expects a `data.aws_iam_policy_document.json`
 *
 * For an example of creating an s3 bucket that will need cross account access, please see [S3 Cross Account Example](https://terraform-docs.cloud.rvapps.io/modules/examples/s3-cross-account-example.html)
 *
 *
 * ## Contributing
 *
 * Please read [CONTRIBUTING.md](https://github.com/RedVentures/terraform-abstraction/CONTRIBUTING.md) for details around contributing to the project.
 *
 * ### Issues
 *
 * Issues have been disabled on this project. Please create issues [here](https://github.com/RedVentures/terraform-abstraction/issues/new/choose)
 */

terraform {
  required_version = ">= 0.12"
}

data "aws_region" "current" {}

locals {
  name = var.global ? var.name : "${var.name}-${var.environment}-${data.aws_region.current.name}"

  default_tags = {
    Name           = local.name
    Service        = "S3 Bucket"
    Environment    = var.environment
    Version        = var.version_tag
    Provisioner    = var.provisioner
    Expiration     = var.expiration_tag
    AssetTag       = var.asset_tag
    Partner        = var.partner
    Project        = var.project
    Owner          = var.owner
    Classification = var.classification
    Backup         = var.backup
  }

  enable = var.enable ? 1 : 0
}

resource "aws_s3_bucket" "bucket" {
  count  = local.enable
  bucket = local.name
  acl    = "private"

  versioning {
    enabled = var.enable_versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_key
      }
    }
  }

  tags = merge(var.tags, local.default_tags)

  lifecycle_rule {
    id      = "expire-all-objects"
    enabled = var.expiration != null ? true : false

    expiration {
      days = var.expiration != null ? var.expiration : "1"
    }
  }

  lifecycle_rule {
    id      = "expire-noncurrent-objects"
    enabled = var.noncurrent_version_expiration != null ? true : false

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration != null ? var.noncurrent_version_expiration : "1"
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  count      = local.enable
  depends_on = [aws_s3_bucket_public_access_block.public_access_block]
  bucket     = aws_s3_bucket.bucket[0].id
  policy     = data.aws_iam_policy_document.default_policy[0].json
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  count = local.enable

  bucket              = aws_s3_bucket.bucket[0].id
  block_public_acls   = true
  block_public_policy = true
}

data "aws_iam_policy_document" "default_policy" {
  count = local.enable

  statement {
    effect = "Deny"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    resources = [
      "${aws_s3_bucket.bucket[0].arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "public-read",
        "public-read-write",
        "authenticated-read",
      ]
    }
  }

  statement {
    effect = "Deny"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    resources = [
      "${aws_s3_bucket.bucket[0].arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-grant-read"

      values = [
        "*http://acs.amazonaws.com/groups/global/AllUsers*",
        "*http://acs.amazonaws.com/groups/global/AuthenticatedUsers*",
      ]
    }
  }

  statement {
    effect = "Deny"

    actions = [
      "s3:PutBucketAcl",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    resources = [
      aws_s3_bucket.bucket[0].arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "public-read",
        "public-read-write",
        "authenticated-read",
      ]
    }
  }

  statement {
    effect = "Deny"

    actions = [
      "s3:PutBucketAcl",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    resources = [
      aws_s3_bucket.bucket[0].arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-grant-read"

      values = [
        "*http://acs.amazonaws.com/groups/global/AllUsers*",
        "*http://acs.amazonaws.com/groups/global/AuthenticatedUsers*",
      ]
    }
  }

  statement {
    effect = "Deny"

    actions = [
      "s3:PutEncryptionConfiguration",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    resources = [
      aws_s3_bucket.bucket[0].arn,
    ]
  }

  source_json = var.bucket_policy
}

