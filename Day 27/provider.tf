terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket       = "demo-terraform-state-bucket-000111"
    key          = "terraform/state/main/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "AWS-Production-Infrastructure"
      ManagedBy   = "Terraform"
    }
  }
}

