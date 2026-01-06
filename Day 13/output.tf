output "instance_id" {
    description = "Demo Instance Id"
    value = aws_instance.demo_instance.id
}

output "instance_private_id" {
    description = "Demo Instance Private Id"
    value = aws_instance.demo_instance.private_ip
}
