output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo-bucket.bucket
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.demo-vpc.id
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.demo-instance.id
}
