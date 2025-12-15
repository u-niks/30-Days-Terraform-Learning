terraform {
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

resource "aws_s3_bucket" "demo-bucket" {
  bucket = "my-tf-demo-bucket"

  tags = {
    Name        = "Demo Bucket"
    Environment = "DEV"
  }
}
