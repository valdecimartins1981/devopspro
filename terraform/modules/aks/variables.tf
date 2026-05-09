variable "cluster_name" {
  description = "AKS cluster name"
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

variable "environment" {
  description = "Environment name (dev, qas, pre-prd, prd)"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "node_count" {
  description = "Number of nodes in the default pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for nodes (A2v2 = Standard_A2_v2)"
  type        = string
  default     = "Standard_A2_v2"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 32
}

variable "subnet_id" {
  description = "Subnet ID for AKS nodes"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for node pools"
  type        = list(string)
  default     = ["1", "2"]
}

variable "enable_auto_scaling" {
  description = "Enable cluster autoscaler"
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Minimum node count when autoscaling is enabled"
  type        = number
  default     = 2
}

variable "max_node_count" {
  description = "Maximum node count when autoscaling is enabled"
  type        = number
  default     = 5
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for monitoring"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
