variable "name" {
  description = "Base name for IAM resources."
  type        = string
}

variable "path" {
  description = "IAM path for the role."
  type        = string
  default     = "/"
}

variable "description" {
  description = "Description for the IAM role."
  type        = string
  default     = "Managed by Terraform"
}

variable "assume_role_policy" {
  description = "JSON trust policy document for the role."
  type        = string
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "JSON inline policy document to attach to the role."
  type        = string
  default     = null
}

variable "create_instance_profile" {
  description = "Whether to create an IAM Instance Profile for this role."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
