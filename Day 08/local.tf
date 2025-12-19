locals {
    common_tags = {
        Environmet  = var.environment
        LOB         = "Engineering"
        ManagedBy   = "Terraform"
    }
}
