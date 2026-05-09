variable "frontdoor_name" {
  description = "Name of the Azure Front Door profile"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "sku_name" {
  description = "Front Door SKU (Standard_AzureFrontDoor or Premium_AzureFrontDoor)"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "origin_host_name" {
  description = "Origin host name (e.g. App Gateway public IP or FQDN)"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
