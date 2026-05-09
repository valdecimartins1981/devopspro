variable "apim_name" {
  description = "Name of the API Management instance"
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

variable "publisher_name" {
  description = "Publisher name for APIM"
  type        = string
  default     = "DevOpsPro"
}

variable "publisher_email" {
  description = "Publisher email for APIM"
  type        = string
}

variable "sku_tier" {
  description = "APIM SKU tier (Developer, Basic, Standard, Premium)"
  type        = string
  default     = "Developer"
}

variable "sku_capacity" {
  description = "APIM SKU capacity (number of units)"
  type        = number
  default     = 1
}

variable "subnet_id" {
  description = "Subnet ID for VNet integration"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
