variable "appgw_name" {
  description = "Name of the Application Gateway"
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

variable "subnet_id" {
  description = "Subnet ID for the Application Gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU name for Application Gateway (Standard_v2 or WAF_v2)"
  type        = string
  default     = "WAF_v2"
}

variable "sku_tier" {
  description = "SKU tier for Application Gateway (Standard_v2 or WAF_v2)"
  type        = string
  default     = "WAF_v2"
}

variable "capacity" {
  description = "Number of Application Gateway instances"
  type        = number
  default     = 2
}

variable "enable_waf" {
  description = "Enable Web Application Firewall"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
