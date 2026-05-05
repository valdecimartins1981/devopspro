output "vpc_id" {
  description = "PROD VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "PROD public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "PROD private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "eks_cluster_endpoint" {
  description = "PROD EKS API server endpoint."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_id" {
  description = "PROD EKS cluster ID."
  value       = module.eks.cluster_id
}

output "db_endpoint" {
  description = "PROD database endpoint."
  value       = module.db.db_instance_endpoint
}

output "s3_bucket_id" {
  description = "PROD S3 bucket name."
  value       = module.app_bucket.bucket_id
}
