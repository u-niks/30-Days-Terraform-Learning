# Day 6: File Structure

## Topics Covered
- Terraform file organization
- Sequence of file loading
- Best practices for file structure
- Code organization patterns

### Terraform File Loading
- Terraform loads all `.tf` files in the current directory
- Files are loaded in **lexicographical order** (alphabetical)
- File names don't affect functionality, only organization
- All `.tf` files are merged into a single configuration

### Recommended File Structure
```
project-root/
├── backend.tf              # Backend configuration
├── provider.tf             # Provider configurations
├── variables.tf            # Input variable definitions
├── locals.tf               # Local value definitions
├── main.tf                 # Main resource definitions
├── vpc.tf                  # VPC-related resources
├── security.tf             # Security groups, NACLs
├── compute.tf              # EC2, Auto Scaling, etc.
├── storage.tf              # S3, EBS, EFS resources
├── database.tf             # RDS, DynamoDB resources
├── outputs.tf              # Output definitions
├── terraform.tfvars        # Variable values
└── README.md               # Documentation
```

### File Organization Principles
1. **Separation of Concerns**: Group related resources together
2. **Logical Grouping**: Organize by service or function
3. **Consistent Naming**: Use clear, descriptive file names
4. **Modular Approach**: Keep files focused on specific areas
5. **Documentation**: Include README and comments

## Tasks for Practice

### Task: Reorganize Previous Files
Using the files from Day 5, divide the configuration into separate files:

#### backend.tf
```hcl
terraform {
  backend "s3" {
    bucket = "demo-tf-state-file-bucket-001"
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
```

#### provider.tf
```hcl
provider "aws" {
  region = "us-east-1"
}
```

#### variables.tf
```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Default Region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "my-terraform-bucket"
}

variable "project" {
  description = "Project Name"
  type        = string
  default     = "Terraform-Deom"
}

variable "tag-name-prefix" {
  description = "Prefix for tag name"
  type        = string
  default     = "Demo"
}

variable "tag-name-suffix" {
  description = "Suffix for tag name"
  type        = string
  default   = "for-terraform-project"
}
```

#### locals.tf
```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
  }
  
  full_bucket_name  = "${var.environment}-${var.bucket_name}-0011"
}
```

#### main.tf
```hcl
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
```

#### outputs.tf
```hcl
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo-bucket.bucket
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.demo-vpc.id
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.demo-instance.id
}
```

### Advanced File Organization Patterns

#### Environment-Specific Structure
```
environments/
├── dev/
│   ├── backend.tf
│   ├── terraform.tfvars
│   └── main.tf
├── staging/
│   ├── backend.tf
│   ├── terraform.tfvars
│   └── main.tf
└── production/
    ├── backend.tf
    ├── terraform.tfvars
    └── main.tf

modules/
├── vpc/
├── security/
└── compute/

shared/
├── variables.tf
├── outputs.tf
└── locals.tf
```

#### Service-Based Structure
```
infrastructure/
├── networking/
│   ├── vpc.tf
│   ├── subnets.tf
│   └── routing.tf
├── security/
│   ├── security-groups.tf
│   ├── nacls.tf
│   └── iam.tf
├── compute/
│   ├── ec2.tf
│   ├── autoscaling.tf
│   └── load-balancers.tf
├── storage/
│   ├── s3.tf
│   ├── ebs.tf
│   └── efs.tf
└── data/
    ├── rds.tf
    ├── dynamodb.tf
    └── elasticache.tf
```

### Best Practices

1. **Consistent Naming**
   - Use clear, descriptive file names
   - Follow team conventions
   - Use lowercase with hyphens or underscores

2. **Logical Grouping**
   - Group related resources together
   - Separate by AWS service or function
   - Consider dependencies when organizing

3. **Size Management**
   - Keep files manageable (< 500 lines)
   - Split large files by functionality
   - Use modules for reusable components

4. **Dependencies**
   - Place provider and backend configs first
   - Define variables before using them
   - Output values at the end

5. **Documentation**
   - Include README.md
   - Comment complex configurations
   - Document variable purposes

### Commands for Testing
```bash
# Validate the reorganized structure
terraform validate

# Format all files consistently
terraform fmt -recursive

# Plan to ensure no changes
terraform plan

# Apply if everything looks good
terraform apply
```

### Common File Organization Mistakes

1. **Everything in main.tf** - Makes code hard to navigate
2. **Inconsistent naming** - Confuses team members
3. **Mixed concerns** - Resources that don't belong together
4. **No documentation** - Difficult for others to understand
5. **Overly complex structure** - Simple is often better

