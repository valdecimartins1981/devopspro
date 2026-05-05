variable "name" {
  description = "Name prefix for the Security Group."
  type        = string
}

variable "description" {
  description = "Description for the Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID of the VPC where the Security Group will be created."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rule objects."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_ipv4   = optional(string)
    description = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
