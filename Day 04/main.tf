terraform {
  backend "s3" {
    bucket = "demo-bucket-for-state-file"
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
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo-bucket" {
  bucket = "my-tf-demo-bucket"

  tags = {
    Name        = "Demo Bucket"
    Environment = "DEV"
  }
}
