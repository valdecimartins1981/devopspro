variable "key_vault_name" {
  description = "Name of the Key Vault (must be globally unique, 3-24 alphanumeric and hyphens)"
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

variable "sku_name" {
  description = "Key Vault SKU (standard or premium)"
  type        = string
  default     = "standard"
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint and network rules"
  type        = string
}

variable "aks_identity_principal_id" {
  description = "AKS managed identity principal ID for Key Vault access"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
