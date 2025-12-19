# =====================================================================================
# Output Variables - Demonstrating different output patterns with count and for_each
# =====================================================================================


# -----------------------------------------------------------------------------
# Outputs for COUNT-based resources
# -----------------------------------------------------------------------------

# Using splat expression to get all bucket names
output "s3_bucket_names_count" {
  description = "Names of S3 buckets created with count"
  value       = aws_s3_bucket.count_example[*].id
}

# Using splat expression to get all bucket ARNs
output "s3_bucket_arns_count" {
  description = "ARNs of S3 buckets created with count"
  value       = aws_s3_bucket.count_example[*].arn
}


# -----------------------------------------------------------------------------
# Outputs for FOR_EACH-based resources
# -----------------------------------------------------------------------------

# Using for loop to get bucket names from for_each
output "s3_bucket_names_foreach" {
  description = "Names of S3 buckets created with for_each (using for loop)"
  value       = [for bucket in aws_s3_bucket.foreach_example : bucket.id]
}

# Creating a map output with bucket names and ARNs
output "s3_bucket_details_foreach" {
  description = "Map of bucket names to ARNs from for_each"
  value = {
    for key, bucket in aws_s3_bucket.foreach_example :
    key => {
      id  = bucket.id
      arn = bucket.arn
    }
  }
}



# -----------------------------------------------------------------------------
# Outputs for DEPENDS_ON meta-argument example resources
# -----------------------------------------------------------------------------

# depends_on example outputs
output "primary_bucket_id" {
  description = "Primary bucket ID "
  value       = aws_s3_bucket.primary_bucket.id
}

output "dependent_bucket_id" {
  description = "Dependent bucket ID"
  value       = aws_s3_bucket.dependant_bucket.id
}
