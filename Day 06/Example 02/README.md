## File Structure
```
project-root/
├── backend.tf               # Backend configuration
├── provider.tf              # Provider configurations
├── variables.tf             # Input variable definitions
├── locals.tf                # Local value definitions
├── vpc.tf                   # VPC-related resources
├── storage.tf               # S3, EBS, EFS resources
├── outputs.tf               # Output definitions
├── terraform.tfvars         # Variable values
└── README.md                # Documentation
```

## Tasks for Practice

### Task: Reorganize Previous Files

#### backend.tf
```hcl
terraform {
    required_version = ">= 1.0"

    backend "s3" {
        bucket       = "demo-terraform-state-bucket-001"
        key          = "dev/terraform.tfstate"
        region       = "us-east-1"
        encrypt      = true
        use_lockfile = true
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }

        random = {
            source  = "hashicorp/random"
            version = "~> 3.1"
        }
    }
}
```

#### provider.tf
```hcl
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.common_tags
  }
}
```

#### variables.tf
```hcl
variable "environment" {
    description = "Environment Name (dev, staging, production)"
    type        = string
    default     = "staging"

    validation {
        condition     = contains(["dev", "staging", "production"], var.environment)
        error_message = "Environment must be dev, staging or production."
    }
}

variable "region" {
    description = "AWS region for resources"
    type        = string
    default     = "us-west-1"
}

variable "project_name" {
    description = "Name of the project"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type        = string
    default     = "10.0.0.0/24"

    validation {
        condition     = can(cidrhost(var.vpc_cidr, 0))
        error_message = "VPC CIDR must be a valid IPv4 CIDR block"
    }
}

variable "availability_zones" {
    description = "List of availabilty zones"
    type        = list(string)
    default     = ["us-east-1a", "us-east-1b"]

}

variable "tags" {
    description = "Additional tags to apply to resources"
    type        = map(string)
    default     = {}
}
```

#### locals.tf
```hcl
locals {

    # Common tags applied to all resources
    common_tags = merge(var.tags, {
        Environment = var.environment
        Project     = var.project_name
        ManagedBy   = "Terraform"
        CreatedDate = formatdate("DD-MM-YYYY", timestamp())
    })

    # Naming convention
    name_prefix = "${var.project_name}-${var.environment}"

    # Network configuration
    vpc_name = "${local.name_prefix}-vpc"
     
    # Storage configuration
    bucket_name = "${local.name_prefix}-${random_id.bucket_suffix.hex}"
}

# Random suffix for globally unique names
resource "random_id" "bucket_suffix" {
    byte_length = 4

    keepers = {
        project     = var.project_name
        environment = var.environment
    }
}
```

#### vpc.tf
```hcl
# VPC
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = merge(local.common_tags, {
        Name = local.vpc_name
    })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = merge(local.common_tags, {
        Name = "${local.name_prefix}-igw"
    })
}

# public subnet
resource "aws_subnet" "public" {
    count = length(var.availability_zones)

    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.vpc_cidr
    availability_zone       = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = merge(local.common_tags, {
        Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
        Type = "Public"
    })
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = merge(local.common_tags, {
        Name = "${local.name_prefix}-public-rt"
    })
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)

    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}
```

#### storage.tf
```hcl
# S3 Bucket
resource "aws_s3_bucket" "main" {
    bucket = local.bucket_name

    tags = merge(local.common_tags, {
        Name        = local.bucket_name
        Purpose     = "General Storage"
        Environment = var.environment
    })
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "main" {
    bucket = aws_s3_bucket.main.id

    versioning_configuration {
      status = "Enabled"
    }
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
    bucket = aws_s3_bucket.main.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
        bucket_key_enabled = true
    }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
    bucket = aws_s3_bucket.main.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}
```

#### output.tf
```hcl
# VPC Outputs
output "vpc_id" {
    description = "ID of the vpc"
    value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
    description = "CIDR block of the vpc"
    value       = aws_vpc.main.cidr_block
}

output "vpc_arn" {
    description = "ARN of the vpc"
    value       = aws_vpc.main.arn
}

# Public Subnet Output
output "public_subnet_ids" {
    description = "IDs of the public subnet"
    value       = aws_subnet.public[*].id
}

output "public_subnet_cidr" {
    description = "CIDR blocks of the public subnet"
    value       = aws_subnet.public[*].cidr_block
}

# S3 Bucket Output
output "s3_bucket_name" {
    description = "Name of the S3 bucket"
    value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_arn" {
    description = "ARN of the S3 bucket"
    value       = aws_s3_bucket.main.arn
}

output "s3_bucket_domain_name" {
    description = "Domain name of the S3 bucket"
    value       = aws_s3_bucket.main.bucket_domain_name
}

# Environment Output
output "environment" {
    description = "Environment Name"
    value = var.environment
}

output "region" {
    description = "AWS Region"
    value = var.region
}

output "common_tags" {
    description = "Common tags applied to resources"
    value       = local.common_tags
}
```

#### terraform.tfvars
```hcl
# Project Configuration
project_name = "aws-terraform-learning"
environment  = "demo"
region       = "us-east-1"

# Network Configuration
vpc_cidr           = "10.0.0.0/24"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Tags
tags = {
  Owner      = "DevOPS team"
  Department = "Engineering"
  CostCenter = "Engineering-001"
  Project    = "TerraformLearning"
}
```

### Commands for Testing
```bash
terraform validate              # Validate the reorganized structure
terraform fmt -recursive        # Format all files consistently
terraform plan                  # Plan to ensure no changes
terraform apply                # Apply if everything looks good
```
