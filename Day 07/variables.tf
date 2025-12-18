# string type
variable "environment" {
    description = "the environment type"
    type        = string
    default     = "dev"
}

variable "region" {
    description = "the aws region"
    type        = string
    default     = "us-east-1"
}

variable "instance_type" {
    description = "the ec2 instance type"
    type        = string
    default     = "t2.micro"
}

# number type
variable "instance_count" {
    description = "the number of ec2 instance to create"
    type        = number
    default     = 1
}

variable "storage_size" {
    description = "the storage size for ec2 instance in GB"
    type        = number
    default     = 8
}

# boolean type
variable "enable_monitoring" {
    description = "enable detailed monitoring for ec2 instance"
    type        = bool
    default     = true
}

variable "associate_public_ip" {
    description = "associate public ip to ec2 instance"
    type        = bool
    default     = true
}

# list type - IMPORTANT: allows duplicates & maintains order
variable "allowed_cidr_block" {
    description = "list of allowed cidr blocks for security group"
    type        = list(string)
    default     = ["10.0.0.0/16", "172.16.0.0/12", "192.168.0.0/16"]

    # access: var.allowed_cidr_blocks[0] = "10.0.0.0/8"
    # can have duplicates: ["10.0.0.0/8", "10.0.0.0/8"] is valid
    # order matters: index 0 = t2.micro, index 1 = t2.small
}

variable "allowed_instance_types" {
    description = "list of allowed ec2 instance types"
    type        = list(string)
    default     = ["t2.micro", "t2.small", "t3.micro"]
}

# Set type - IMPORTANT: duplicates not allowed, order doesn't matter
variable "availability_zones" {
    description = "set of availability zones (no duplicates)"
    type        = set(string)
    default     = ["us-east-1a", "us-east-1b", "us-east-1c"]

    # automatically removes duplicates
    # order is not guaranteed
    # cannot access by index like set[0] - need to convert to list first
}

# Map type - IMPORTANT: key-value pairs, keys must be unique
variable "instance_tags" {
    description = "tags to apply to the ec2 instances"
    type        = map(string)
    default     = {
      "Environment" = "dev"
      "Project"     = "Terraform"
      "Owner"       = "DevOPS Team"
    }

    # access: var.instance_tags["Environment"] = "dev"
    # keys are always strings, values must match the declared type
}

# Tuple type - IMPORTANT: fixed length, each position has specific type
variable "network_config" {
    description = "Network configuration (VPC CIDR, subnet CIDR, port number)"
    type        = tuple([ string, string, number ])
    default     = [ "10.0.0.0/16", "10.0.1.0/24", 80 ]

    # tuple follows rules:
    # position 0 must be string (VPC CIDR)
    # position 1 must be string (subnet CIDR)  
    # position 2 must be number (port)
    # length is fixed - cannot add/remove elements
    # access: var.network_config[0], var.network_config[1], var.network_config[2]
}

# Object type - IMPORTANT: named attributes with specific types
variable "server_config" {
    description = "Complete server configuration object"
    type = object({
        name           = string
        instance_type  = string
        monitoring     = bool
        starage_gb     = number
        backup_enabled = bool
    })

    default = {
        name = "web-server"
        instance_type = "t2.micro"
        monitoring = true
        starage_gb = 20
        backup_enabled = false
    }

    # self-documenting structure
    # type safety for each attribute
    # access: var.server_config.name, var.server_config.monitoring
    # all attributes must be provided (unless optional)
}
