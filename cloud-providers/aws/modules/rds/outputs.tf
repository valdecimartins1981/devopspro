output "db_instance_id" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.id
}

output "db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = aws_db_instance.this.endpoint
}

output "db_instance_arn" {
  description = "ARN of the RDS instance."
  value       = aws_db_instance.this.arn
}

output "db_subnet_group_name" {
  description = "Name of the DB Subnet Group."
  value       = aws_db_subnet_group.this.name
}
