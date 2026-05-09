variable "postgresql_name" {
  description = "Name of the PostgreSQL Flexible Server"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "postgresql_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15"
}

variable "admin_username" {
  description = "Administrator login for PostgreSQL"
  type        = string
  default     = "psqladmin"
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "PostgreSQL SKU name (e.g. B_Standard_B1ms, GP_Standard_D2s_v3)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Storage size in MB (102400 = 100GB, 81920 = 80GB)"
  type        = number
  default     = 102400
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup" {
  description = "Enable geo-redundant backups"
  type        = bool
  default     = false
}

variable "high_availability_mode" {
  description = "High availability mode (Disabled, ZoneRedundant, SameZone)"
  type        = string
  default     = "Disabled"
}

variable "subnet_id" {
  description = "Delegated subnet ID for PostgreSQL VNet integration"
  type        = string
}

variable "vnet_id" {
  description = "VNet ID for private DNS zone link"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
