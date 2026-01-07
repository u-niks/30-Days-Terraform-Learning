# Outputs for VPC Peering Demo

# Primary VPC id
output "primary_vpc_id" {
    description = "ID of the Primary VPC"
    value       = aws_vpc.primary_vpc.id
}

# Secondary VPC id
output "secondary_vpc_id" {
    description = "ID of the Secondary VPC"
    value       = aws_vpc.secondary_vpc.id
}

# Primary VPC CIDR
output "primary_vpc_cidr" {
    description = "CIDR block of the Primary VPC"
    value       = aws_vpc.primary_vpc.cidr_block
}

# Secondary VPC CIDR
output "secondary_vpc_cidr" {
    description = "CIDR block of the Secondary VPC"
    value       = aws_vpc.secondary_vpc.cidr_block
}

# Primary to Secondary VPC Peering Connection id
output "primary_to_secondary_vpc_peering_connection_id" {
    description = "ID of the Primary to Secondary VPC Peering Connection"
    value       = aws_vpc_peering_connection.primary_to_secondary_peering.id
}

# Acceptance Status of Primary to Secondary VPC Peering Connection
output "primary_to_secondary_vpc_peering_status" {
    description = "Status of Primary to Secondary VPC Peering Connection"
    value       = aws_vpc_peering_connection.primary_to_secondary_peering.id
}

# Acceptance Status of Secondary to Primary VPC Peering Connection
output "secondary_to_primary_vpc_peering_status" {
    description = "Status of Secondary to Primary VPC Peering Connection"
    value       = aws_vpc_peering_connection.primary_to_secondary_peering.accept_status
}

# Primary Instance id
output "primary_instance_id" {
    description = "ID of the Primary EC2 Instance"
    value       = aws_instance.primary_instance.id
}

# Secondary Instance id
output "secondary_instance_id" {
    description = "ID of the Secondary EC2 Instance"
    value       = aws_instance.secondary_instance.id
}

# Private IP of Primary Instance
output "primary_instance_private_ip" {
    description = "Private IP of the Primary EC2 Instance"
    value       = aws_instance.primary_instance.private_ip
}

# Private IP of Secondary Instance
output "secondary_instance_private_ip" {
    description = "Private IP of the Secondary EC2 Instance"
    value       = aws_instance.secondary_instance.private_ip
}

# Public IP of Primary Instance
output "primary_instance_public_ip" {
    description = "Public IP of the Primary EC2 Instance"
    value       = aws_instance.primary_instance.public_ip
}

# Public IP of Secondary Instance
output "secondary_instance_public_ip" {
    description = "Public IP of the Secondary EC2 Instance"
    value       = aws_instance.secondary_instance.public_ip
}

# Testing Connectivity
output "test_connectivity_command" {
    description = "Command to test connectivity between VPCs"
    value       = <<-EOT
        To test VPC peering connectivity:
        1. SSH into Primary instance: ssh -i your-key.pem ubuntu@${aws_instance.primary_instance.public_ip}
        2. Ping Secondary instance: ping ${aws_instance.secondary_instance.private_ip}
        
        Or:
        1. SSH into Secondary instance: ssh -i your-key.pem ubuntu@${aws_instance.secondary_instance.public_ip}
        2. Ping Primary instance: ping ${aws_instance.primary_instance.private_ip}
    EOT
}
