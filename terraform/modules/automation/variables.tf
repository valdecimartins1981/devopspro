variable "automation_account_name" {
  description = "Name of the Automation Account"
  type        = string
}

variable "environment" {
  description = "Environment name for the Log Analytics Workspace"
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

variable "aks_cluster_name" {
  description = "AKS cluster name for start/stop runbooks"
  type        = string
}

variable "aks_cluster_id" {
  description = "AKS cluster resource ID for role assignment"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
