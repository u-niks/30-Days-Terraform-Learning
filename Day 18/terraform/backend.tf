terraform {
    backend "s3" {
        bucket       = "image-processing-app-terraform-state-bvucket-111000"
        key          = "prod/terraform.tfstate"
        region       = "us-east-1"
        encrypt      = true
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }

        archive = {
            source  = "hashicorp/archive"
            version = "~> 2.4"
        }

        random = {
            source  = "hashicorp/random"
            version = "~> 3.6"
        }
    }
}

provider "aws" {
    region = var.aws_region

    default_tags {
        tags = {
            Project     = "ImageProcessingApplication"
            Environment = var.environment
            ManagedBy   = "Terraform"
        }
    }
}
