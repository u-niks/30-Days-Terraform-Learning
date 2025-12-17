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
