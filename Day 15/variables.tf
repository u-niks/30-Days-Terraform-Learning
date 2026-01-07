# Variables for VPC Peering Demo

# Primary region
variable "primary_region" {
    description = "Primary AWS region for the first VPC"
    type        = string
    default     = "us-east-1"
}

# Secondary Region
variable "secondary_region" {
    description = "Secondary AWS region for the first VPC"
    type        = string
    default     = "us-west-2"
}

# Primary VPC CIDR
variable "primary_vpc_cidr" {
    description = "CIDR block for the primary VPC"
    type        = string
    default     = "10.0.0.0/16"
}

# Secondary VPC CIDR
variable "secondary_vpc_cidr" {
    description = "CIDR block for the Secondory VPC"
    type        = string
    default     = "10.1.0.0/16"
}

# Primary Subnet CIDR
variable "primary_subnet_cidr" {
    description = "CIDR block for the primary subnet"
    type        = string
    default     = "10.0.1.0/24"
}

# Secondary Subnet CIDR
variable "secondary_subnet_cidr" {
    description = "CIDR block for the Secondary subnet"
    type        = string
    default     = "10.1.1.0/24"
}

# Instance Type
variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}

# Primary Key Name
variable "primary_key_name" {
    description = "Name of the SSH key pair for Primary VPC instance (us-east-1)"
    type        = string
    default     = ""
}

# Secondary Key Name
variable "secondary_key_name" {
    description = "Name of the SSH key pair for Secondary VPC instance (us-west-2)"
    type        = string
    default     = ""
    }

# General Variables

# Environment
variable "environment" {
    description = "Project Environment"
    type        = string
    default     = "dev"
}
