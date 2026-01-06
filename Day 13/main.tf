# Data source to get the existing VPC
data "aws_vpc" "default_vpc" {
    filter {
        name = "tag:Name"
        values = [ "shared-network-vpc" ]
    }
}

# Data source to get the existing subnet
data "aws_subnet" "default_subnet" {
    filter {
        name = "tag:Name"
        values = [ "shared-primary-subnet" ]
    }
    vpc_id = data.aws_vpc.default_vpc.id
}

# Data source for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
    most_recent = true
    owners      = [ "amazon" ]

    filter {
        name   = "name"
        values = [ "amzn2-ami-hvm-*-x86_64-gp2" ]
    }

    filter {
        name   = "virtualization-type"
        values = [ "hvm" ]
    }
}

resource "aws_instance" "demo_instance" {
    ami           = data.aws_ami.amazon_linux_2.id
    instance_type = "t2.micro"
    subnet_id     = data.aws_subnet.default_subnet.id
    private_ip    = "172.31.32.20"

    tags = {
        Name = "Demo Instance"
    }
}
