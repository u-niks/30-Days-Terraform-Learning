terraform {
  backend "s3" {
    bucket       = "demo-tf-state-file-bucket-001"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


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

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
  }

  full_bucket_name = "${var.environment}-${var.bucket_name}-0011"
}

resource "aws_s3_bucket" "demo-s3-bucket" {
  bucket = local.full_bucket_name
  tags = merge(
    local.common_tags, {
      Name = "Demo-S3-Bucket-for-Terraform-Project"
    }
  )
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/24"
  region     = var.region

  tags = {
    Name        = "Demo-VPC-for-Terraform-Project"
    Environment = var.environment
  }
}

resource "aws_instance" "demo-instance" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  region        = var.region

  tags = {
    Name        = "Demo-EC2-Instance-for-Terraform-Project"
    Environment = var.environment
  }
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo-s3-bucket.bucket
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.demo-vpc.id
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.demo-instance.id
}
