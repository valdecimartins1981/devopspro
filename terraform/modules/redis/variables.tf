variable "redis_name" {
  description = "Name of the Redis Cache instance"
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

variable "capacity" {
  description = "Redis capacity (C0=250MB, C1=1GB, C2=6GB, etc.)"
  type        = number
  default     = 0
}

variable "family" {
  description = "Redis SKU family (C for Basic/Standard, P for Premium)"
  type        = string
  default     = "C"
}

variable "sku_name" {
  description = "Redis SKU name (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "subnet_id" {
  description = "Subnet ID for the private endpoint"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
