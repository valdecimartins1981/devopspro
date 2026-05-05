output "vpc_id" {
  description = "UAT VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "UAT public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "UAT private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "app_instance_ids" {
  description = "UAT application instance IDs."
  value       = module.app_server.instance_ids
}

output "db_endpoint" {
  description = "UAT database endpoint."
  value       = module.db.db_instance_endpoint
}

output "s3_bucket_id" {
  description = "UAT S3 bucket name."
  value       = module.app_bucket.bucket_id
}
