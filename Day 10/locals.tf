# Use splat expressions to extract values from all instances
locals {
    # Get all instance IDs in one line using [*]
    all_instance_ids = aws_instance.splat_example[*].id
  
    # Get all private IPs using [*]
    all_private_ips = aws_instance.splat_example[*].private_ip
}
