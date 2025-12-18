locals {
    # Common tags to apply to all resources
    common_tags = {
        Environment = var.environment
        ManagedBy   = "DevOPS Team"
        LOB         = "Engineering"
        Stage       = "Alpha"
        CreatedDate = formatdate("DD-MM-YYYY", timestamp())
    }

    # Network configuration from tuple
    vpc_cidr = element(var.network_config, 0)
    subnet_cidr = "${element(var.network_config, 1)}/${element(var.network_config,2)}"

    # Instance configuration
    instance_name = "${var.environment}-instance"

    # Security group ports as map
    port_description = {
        22  = "SSH"
        80  = "HTTP"
        443 = "HTTPS"
    }
}
