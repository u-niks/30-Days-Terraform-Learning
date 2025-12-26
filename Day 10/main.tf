# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
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


# ==============================================================================
# EXAMPLE 1: CONDITIONAL EXPRESSIONS
# ==============================================================================
# This example shows how to choose instance type based on environment
# - If environment is "prod", use t3.large
# - Otherwise, use t2.micro
# ==============================================================================

resource "aws_instance" "conditional_example" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = var.environment == "dev" ? var.instance_type[0] : var.instance_type[1]

    vpc_security_group_ids = [ aws_security_group.dynamic_sg.id ]

    tags = {
        Name = "conditional-instance-${var.environment}"
    }
}


# ==============================================================================
# EXAMPLE 2: DYNAMIC BLOCKS
# ==============================================================================
# This example creates multiple security group rules from a list variable
# - No need to repeat ingress blocks manually
# - Add/remove rules by editing the ingress_rules variable
# ==============================================================================

resource "aws_security_group" "dynamic_sg" {
    name        = "dynamic-sg-${var.environment}"
    description = "Security group with dynamic rules"

    # Dynamic block creates multiple ingress rules from a list
    dynamic "ingress" {
        for_each = var.ingress_rules
        content {
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
            description = ingress.value.description
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "dynamic-sg-${var.environment}"
    }
}


# ==============================================================================
# EXAMPLE 3: SPLAT EXPRESSIONS
# ==============================================================================
# This example creates multiple instances and uses splat [*] to extract values
# - Creates 'instance_count' number of instances
# - Extracts all IDs and IPs in a single expression
# ==============================================================================

resource "aws_instance" "splat_example" {
    count         = var.instance_count
    ami           = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type[0]

    tags = {
        Name = "instance-${count.index + 1}"
    }
}
