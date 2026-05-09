variable "acr_name" {
  description = "Name of the Container Registry (must be globally unique, alphanumeric only)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "ACR SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Premium"
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint and network rules"
  type        = string
}

variable "aks_kubelet_principal_id" {
  description = "Principal ID of the AKS kubelet identity for AcrPull role assignment"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
