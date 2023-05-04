output "arn" {
  description = "The ARN of the bucket"
  value       = element(concat(aws_s3_bucket.bucket.*.arn, [""]), 0)
}

output "name" {
  description = "The name of the bucket"
  value       = element(concat(aws_s3_bucket.bucket.*.id, [""]), 0)
}

output "bucket_domain_name" {
  description = "The bucket domain name. This would be used to as the s3 origin in a cloudfront resoruce"
  value       = element(concat(aws_s3_bucket.bucket.*.bucket_domain_name, [""]), 0)
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name."
  value       = element(concat(aws_s3_bucket.bucket.*.bucket_regional_domain_name, [""]), 0)
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region"
  value       = element(concat(aws_s3_bucket.bucket.*.hosted_zone_id, [""]), 0)
}

output "region" {
  description = "The AWS region this bucket resides in"
  value       = element(concat(aws_s3_bucket.bucket.*.region, [""]), 0)
}
