# VPC
variable "vpc_id" {}

data "aws_vpc" "selected" {
    id      = var.vpc_id
    default = true
}

# Security Group
resource "aws_security_group" "test_sg" {
    name        = "test-sg"
    description = "Allow SSH, HTTP and HTTPS"
    vpc_id      = data.aws_vpc.selected.id

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "Allow HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        description = "Allow all outbound"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}
