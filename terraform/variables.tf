variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "environments" {
  description = "List of environments to deploy"
  type        = list(string)
  default     = ["dev", "qas", "pre-prd", "prd"]
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "DevOpsPro"
  }
}
