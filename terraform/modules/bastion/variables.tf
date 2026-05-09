variable "bastion_name" {
  description = "Name of the Bastion host"
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

variable "vnet_name" {
  description = "VNet name (for AzureBastionSubnet creation)"
  type        = string
}

variable "bastion_subnet_prefixes" {
  description = "Address prefixes for the AzureBastionSubnet (minimum /26)"
  type        = list(string)
  default     = ["10.0.3.0/26"]
}

variable "private_subnet_id" {
  description = "Private subnet ID for the bastion VM NIC"
  type        = string
}

variable "sku" {
  description = "Bastion SKU (Basic, Standard)"
  type        = string
  default     = "Standard"
}

variable "vm_size" {
  description = "VM size for the bastion management VM (Standard_D2_v4 as per diagram)"
  type        = string
  default     = "Standard_D2_v4"
}

variable "admin_username" {
  description = "Admin username for the bastion VM"
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the bastion VM admin user"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
