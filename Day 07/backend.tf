terraform {
    backend "s3" {
        bucket = "demo-terraform-state-0011"
        key = "dev/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }

        random = {
            source = "hashicorp/random"
            version = "~> 3.1"
        }
    }
}
