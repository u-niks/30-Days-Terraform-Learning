terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

# Provider for the primary region (us-east-1)
provider "aws" {
    region = "us-east-1"
}

