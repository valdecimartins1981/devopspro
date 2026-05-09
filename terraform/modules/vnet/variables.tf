variable "vnet_name" {
  description = "Name of the virtual network"
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

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "private_subnet_prefixes" {
  description = "Address prefixes for the private subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "appgw_subnet_prefixes" {
  description = "Address prefixes for the App Gateway subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
