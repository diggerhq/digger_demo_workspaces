variable "name" {
  type        = string
  description = "(String) The name of the bucket to create."
}

variable "project" {
  type        = string
  description = "(String) The project that the bucket belongs to"
}

variable "enable" {
  type        = bool
  default     = true
  description = "(Boolean) whether or not to create this module"
}

variable "enable_versioning" {
  type        = bool
  default     = false
  description = "(Boolean) Whether or not to enable versioning"
}

variable "sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "(String) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms [default: aws:kms]"
}

variable "kms_key" {
  type        = string
  default     = null
  description = "(String) The kms key to use for encryption. Uses aws/s3 kms key by default"
}

variable "environment" {
  type        = string
  description = "(String) The environment the bucket belongs to"
}

variable "global" {
  type        = bool
  description = "(Boolean) Set this to true to remove the environment/region suffix from the bucket name"
  default     = false
}

variable "bucket_policy" {
  type        = string
  description = "(String) An optional iam policy document statement to append to the default policy."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "(Map) Optionally specify additional tags to add to the bucket"
  default     = {}
}

variable "expiration" {
  type        = string
  description = "(String) Number of days before objects should expire"
  default     = null
}

variable "noncurrent_version_expiration" {
  type        = string
  description = "(String) Number of days before non-current objects should expire"
  default     = null
}

/* 
* Begin CNN Tag Variables
*/

variable "version_tag" {
  type        = string
  description = "Distinguish between different versions of the resource"
  default     = "n/a"
}

variable "provisioner" {
  type        = string
  description = "Tool used to provision the resource"
  default     = "terraform://terraform-aws-s3"
}

variable "asset_tag" {
  type        = string
  description = "This value should be identified via SNOW"
  default     = "n/a"
}

variable "partner" {
  type        = string
  description = "Business unit for which the resource is deployed (i.e., AT&T, Verizon, Internal, Shared, etc) See SNOW for more valid options"
}

variable "owner" {
  type        = string
  description = "Email address of the first-level contact for the resource"
}

variable "classification" {
  type        = string
  description = "Coded data sensitivity (Romeo, Sierra, India, Lima, Echo; Sensitive; Restricted; Internal; Limited External; External)"
}

variable "backup" {
  type        = string
  description = "Automation tag which defines backup schedule to apply"
  default     = "n/a"
}

variable "expiration_tag" {
  type        = string
  description = "(String) Date resource should be removed or reviewed"
  default     = "n/a"
}
