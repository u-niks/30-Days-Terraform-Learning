terraform {
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
            version = "~> 6.0"
        }

        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "=> 2.20"
        }

        kubctl = {
            source = "gavinbunney/kubectl"
            version = "=> 1.14.0"
        }

        http = {
            source = "hashicorp/http"
            version = "=> 3.0"
        }

        null = {
            source = "hashicorp/null"
            version = "=> 3.0"
        }
    }
}