
# EC2 Instance Outputs

# All instance IDs (handles count > 1)
output "web_instance_ids" {
  description = "IDs of the web server EC2 instances"
  value       = aws_instance.web_server[*].id
}

# ARNs of the instances
output "web_instance_arns" {
  description = "ARNs of the web server EC2 instances"
  value       = aws_instance.web_server[*].arn
}

# Availability Zones per instance
output "web_instance_azs" {
  description = "Availability zones of the EC2 instances"
  value       = aws_instance.web_server[*].availability_zone
}

# Instance types 
output "web_instance_types" {
  description = "Instance types of the web server EC2 instances"
  value       = aws_instance.web_server[*].instance_type
}

# Public IPs (will be null/empty if associate_public_ip_address = false or in private subnets)
output "web_instance_public_ips" {
  description = "Public IP addresses of the web server instances (if assigned)"
  value       = aws_instance.web_server[*].public_ip
}

# Public DNS names
output "web_instance_public_dns" {
  description = "Public DNS names of the web server instances (if assigned)"
  value       = aws_instance.web_server[*].public_dns
}

# Subnet IDs (in case you attach to subnets elsewhere)
output "web_instance_subnet_ids" {
  description = "Subnet IDs where the EC2 instances are placed"
  value       = aws_instance.web_server[*].subnet_id
}

# Root EBS Volume IDs — one per instance
# Note: root_block_device is a list; with count, we pick the first element per instance.
output "web_instance_root_volume_ids" {
  description = "Root EBS volume IDs of the web server instances"
  value       = [for i in aws_instance.web_server : try(i.root_block_device[0].volume_id, null)]
}

# Full tags map as seen on each instance (after provider default_tags merges)
output "web_instance_effective_tags" {
  description = "Effective tags applied on each EC2 instance"
  value       = aws_instance.web_server[*].tags_all
}

# Security Group Outputs
output "web_sg_id" {
  description = "Security group ID for the web servers"
  value       = aws_security_group.web_sg.id
}

output "web_sg_arn" {
  description = "Security group ARN for the web servers"
  value       = aws_security_group.web_sg.arn
}

output "web_sg_name" {
  description = "Security group name"
  value       = aws_security_group.web_sg.name
}

output "web_sg_vpc_id" {
  description = "VPC ID where the security group is  description"
  value       = aws_security_group.web_sg.vpc_id
}

output "web_sg_tags" {
  description = "Tags applied to the web security group"
  value       = aws_security_group.web_sg.tags_all
}

