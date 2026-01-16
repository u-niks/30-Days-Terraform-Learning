output "instance_id" {
    description = "ID of the demo EC2 instance"
    value       = aws_instance.provisioner_instance.id
}

output "public_ip" {
    description = "Public IP of the demo EC2 instance"
    value       = aws_instance.provisioner_instance.public_ip
}
