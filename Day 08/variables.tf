variable "environment" {
  type        = string
  description = "The environment type"
  default     = "staging"
}

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "s3_bucket_names_list" {
    type      = list(string)
    description = "List of S3 bucket names for count example"
    default = [ "tf-day08-count-bucket-a-20251912", "tf-day08-count-bucket-b-20251912" ]
}

variable "s3_bucket_names_set" {
    type = set(string)
    description = "Set of S3 bucket names for for_each example"
    default = [ "tf-day08-foreach-bucket-a-20251912", "tf-day08-foreach-bucket-b-20251912" ]
}

variable "s3_bucket_names_depends" {
  type = list(string)
  description = "List of S3 bucket names for depends on example"
  default = [ "tf-day08-dependant-bucket-20251912", "tf-day08-primary-bucket-b-20251912"]
}
