terraform {
    backend "s3" {
        bucket       = "demo-terraform-state-file-111000"
        key          = "prod/terraform.tfstate"
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
    region = var.aws_region

    default_tags {
        tags = {
            ManagedBy = "Terraform"
            Project   = "Day20-EKS-Cluster"
        }
    }
}
