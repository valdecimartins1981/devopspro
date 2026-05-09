variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "DevOpsPro"
  }
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}

variable "private_subnet_prefixes" {
  type    = list(string)
  default = ["10.10.1.0/24"]
}

variable "appgw_subnet_prefixes" {
  type    = list(string)
  default = ["10.10.2.0/24"]
}

variable "bastion_subnet_prefixes" {
  type    = list(string)
  default = ["10.10.3.0/26"]
}

variable "kubernetes_version" {
  type    = string
  default = "1.28"
}

# DEV: 1 Cluster, 2 Nodes (A2v2 - 2vCPU 4GB RAM - 32GB Disk)
variable "aks_node_count" {
  type    = number
  default = 2
}

variable "aks_enable_autoscaling" {
  type    = bool
  default = true
}

variable "aks_min_nodes" {
  type    = number
  default = 2
}

variable "aks_max_nodes" {
  type    = number
  default = 4
}

# DEV: PostgreSQL DBMS with 100GB Disk
variable "postgresql_admin_username" {
  type      = string
  sensitive = true
}

variable "postgresql_admin_password" {
  type      = string
  sensitive = true
}

variable "postgresql_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "postgresql_storage_mb" {
  type    = number
  default = 102400
}

variable "postgresql_geo_redundant_backup" {
  type    = bool
  default = false
}

variable "postgresql_ha_mode" {
  type    = string
  default = "Disabled"
}

variable "apim_publisher_name" {
  type    = string
  default = "DevOpsPro"
}

variable "apim_publisher_email" {
  type = string
}

variable "bastion_ssh_public_key" {
  type      = string
  sensitive = true
}
