locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
  }

  full_bucket_name = "${var.environment}-${var.bucket_name}-0011"
}
