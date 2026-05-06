output "bucket_names" {
  description = "Names of the created S3 buckets"
  value       = { for k, v in aws_s3_bucket.env_bucket : k => v.bucket }
}

output "iam_users" {
  description = "List of created IAM users"
  value       = [for user in aws_iam_user.users : user.name]
}
