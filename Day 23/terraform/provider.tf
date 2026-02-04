terraform {
    backend "s3" {
        bucket       = "demo-terrraform-state-file-bucket-000111"
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

        random = {
            source  = "hashicorp/random"
            version = "~> 3.6"
        }

        archive = {
            source  = "hashicorp/archive"
            version = "~> 2.4"
        }
    }
}

provider "aws" {
    region = var.region

    default_tags {
        tags = {
            Project     = "ImageProcessingApp"
            Environment = var.environment
            ManagedBy   = "Terraform"
        }
    }
}
