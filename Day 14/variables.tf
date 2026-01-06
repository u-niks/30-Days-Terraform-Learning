variable "region" {
    type        = string
    description = "AWS Region"
    default     = "us-east-1"
}

variable "bucket_prefix" {
    type        = string
    description = "Prefix for the S3 bucket name."
    default     = "my-static-website-"
}
