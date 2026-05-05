variable "identifier" {
  description = "Unique identifier for the RDS instance."
  type        = string
}

variable "engine" {
  description = "Database engine (mysql, postgres, etc.)."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version."
  type        = string
  default     = "15"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage size in GiB."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the initial database."
  type        = string
}

variable "username" {
  description = "Master username for the database."
  type        = string
}

variable "password" {
  description = "Master password for the database. Use AWS Secrets Manager in production."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port."
  type        = number
  default     = 5432
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB Subnet Group."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of Security Group IDs."
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window (UTC)."
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window."
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "multi_az" {
  description = "Deploy RDS in Multi-AZ mode."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion."
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately instead of during maintenance window."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
