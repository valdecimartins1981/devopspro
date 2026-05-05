output "vpc_id" {
  description = "DEV VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "DEV public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "DEV private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "app_instance_ids" {
  description = "DEV application instance IDs."
  value       = module.app_server.instance_ids
}

output "db_endpoint" {
  description = "DEV database endpoint."
  value       = module.db.db_instance_endpoint
}

output "s3_bucket_id" {
  description = "DEV S3 bucket name."
  value       = module.app_bucket.bucket_id
}
