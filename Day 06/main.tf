resource "aws_s3_bucket" "demo-bucket" {
  bucket = local.full_bucket_name

  tags = merge(
    local.common_tags, {
        Name = "${var.tag-name-prefix}-Bucket-${var.tag-name-suffix}"
    }
  )
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/24"
  region = var.region

  tags = merge(
    local.common_tags, {
        Name = "${var.tag-name-prefix}-VPC-${var.tag-name-suffix}"
    }
  )
}

resource "aws_instance" "demo-instance" {
  ami = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  region = var.region

  tags = merge(
    local.common_tags, {
        Name = "${var.tag-name-prefix}-EC2-Instance-${var.tag-name-suffix}"
    }
  )
}
