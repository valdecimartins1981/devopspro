variable "bucket_name" {
  description = "Globally unique name for the S3 bucket."
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects."
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Block all public access to the bucket."
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rule objects."
  type = list(object({
    id             = string
    prefix         = optional(string, "")
    expiration_days = optional(number)
    transitions    = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
