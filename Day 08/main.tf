# -----------------------------------------------------------------------------
# Example 1: Using COUNT meta-argument with S3 buckets
# -----------------------------------------------------------------------------
# count is useful when you want to create multiple identical resources
# Access individual instances using count.index

resource "aws_s3_bucket" "count_example" {
    count = length(var.s3_bucket_names_list)
    bucket = var.s3_bucket_names_list[count.index]

    tags = merge(local.common_tags, {
        Description = "count Example Bucket"
        Bucket_Name = var.s3_bucket_names_list[count.index]
        Index       = count.index
    })
}


# -----------------------------------------------------------------------------
# Example 2: Using FOR_EACH meta-argument with S3 buckets
# -----------------------------------------------------------------------------
# for_each is useful when you want to create resources from a map or set
# Access individual instances using each.key and each.value
# Note: for_each requires a map or set, not a list

resource "aws_s3_bucket" "foreach_example" {
    for_each = var.s3_bucket_names_set
    bucket = each.value

    tags = merge(local.common_tags, {
        Description = "foreach example bucket"
        Bucket_Name = each.value

    })
}



# -----------------------------------------------------------------------------
# Example 3: DEPENDS_ON meta-argument
# -----------------------------------------------------------------------------
# depends_on is used to explicitly specify dependencies between resources
# Terraform automatically handles most dependencies, but sometimes you need explicit control

resource "aws_s3_bucket" "dependant_bucket" {
    bucket = var.s3_bucket_names_depends[0]

    depends_on = [ aws_s3_bucket.primary_bucket]

    tags = merge(local.common_tags, {
        Description = "Dependant bucket of depends_on example"
        Bucket_Name = var.s3_bucket_names_depends[0]
    })
}

resource "aws_s3_bucket" "primary_bucket" {
    bucket = var.s3_bucket_names_depends[1]

    tags = merge(local.common_tags, {
        Description = "Primary bucket of depends_on example bucket"
        Bucket_Name = var.s3_bucket_names_depends[1]
    })
}
