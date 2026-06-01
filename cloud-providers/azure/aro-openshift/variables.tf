variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region para o cluster"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-aro-estudos"
}

variable "cluster_name" {
  description = "Nome do cluster ARO"
  type        = string
  default     = "aro-estudos"
}

variable "domain" {
  description = "Domínio do cluster (deve ser único)"
  type        = string
  default     = "aroestudos"
}

variable "pull_secret" {
  description = "Red Hat Pull Secret (obtido em console.redhat.com)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "worker_vm_size" {
  description = "Tamanho das VMs Worker (menor custo para estudos)"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "worker_count" {
  description = "Número de Worker Nodes"
  type        = number
  default     = 3
}

variable "master_vm_size" {
  description = "Tamanho das VMs Master"
  type        = string
  default     = "Standard_D8s_v3"
}

variable "pod_cidr" {
  description = "CIDR para os Pods"
  type        = string
  default     = "10.128.0.0/14"
}

variable "service_cidr" {
  description = "CIDR para os Services"
  type        = string
  default     = "172.30.0.0/16"
}

variable "vnet_address_space" {
  description = "Address space da VNet"
  type        = string
  default     = "10.0.0.0/8"
}

variable "master_subnet_cidr" {
  description = "CIDR da subnet dos Masters"
  type        = string
  default     = "10.0.0.0/23"
}

variable "worker_subnet_cidr" {
  description = "CIDR da subnet dos Workers"
  type        = string
  default     = "10.0.2.0/23"
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    Environment = "estudos"
    ManagedBy   = "terraform"
    Project     = "aro-lab"
  }
}
