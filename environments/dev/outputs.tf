output "bucket_arn" {
  description = "The ARN of the dev bucket."
  value       = module.deployment_bucket.bucket_arn
}

output "bucket_name" {
  description = "The name of the dev bucket."
  value       = module.deployment_bucket.bucket_name
}
