# Data Source for AMI
data "aws_ami" "ubuntu_ami" {
    most_recent = true
    owners      = ["099720109477"]      # Canonical (Ubuntu official)
    
    filter {
        name   = "name"
        values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
    }

    filter {
        name   = "virtualization-type"
        values = [ "hvm" ]
    }
}

# Security Group for EC2 Instance
resource "aws_security_group" "allow_ssh" {
    name        = "provisioner-demo-ssh-sg"
    description = "Allow SSH inbound"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

# EC2 Instance
resource "aws_instance" "provisioner_instance" {
    ami                    = data.aws_ami.ubuntu_ami.id
    instance_type          = var.instance_type
    key_name               = var.key_name
    vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]

    tags = {
        Name = "terraform-provisioner-instance/"
    }

    connection {
        type        = "ssh"
        user        = var.ssh_user
        private_key = file(var.private_key_path)
        host        = self.public_ip
    }

    # ---------------------------------------------------------------------
    # Provisioner 1: local-exec
    # - Runs on the machine where you run Terraform (your laptop/CI agent).
    # - Useful for local tasks, logging, calling local scripts, etc.
    # ---------------------------------------------------------------------

    provisioner "local-exec" {
        command = "echo 'local-exec: created instance ${self.id} with IP ${self.public_ip}'"
    }


    # ---------------------------------------------------------------------
    # Provisioner 2: remote-exec
    # - Runs commands on the remote instance over SSH
    # - Requires SSH access (security group + key pair + reachable IP)
    # ---------------------------------------------------------------------

    provisioner "remote-exec" {
        inline = [ 
            "sudo apt-get update",
            "echo 'Hello from remote-exec' | sudo tee /tmp/remote_exec.txt"
        ]
    }

    provisioner "file" {
        source = "${path.module}/script/welcome.sh"
        destination = "/tmp/welcome.sh"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo chmod +x /tmp/welcome.sh",
            "sudo /tmp/welcome.sh"
        ]
    }
}
