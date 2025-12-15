variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Default Region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "my-terraform-bucket"
}

variable "project" {
  description = "Project Name"
  type        = string
  default     = "Terraform-Deom"
}

variable "tag-name-prefix" {
  description = "Prefix for tag name"
  type        = string
  default     = "Demo"
}

variable "tag-name-suffix" {
  description = "Suffix for tag name"
  type        = string
  default     = "for-terraform-project"
}
