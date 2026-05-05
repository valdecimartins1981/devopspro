variable "name" {
  description = "Name tag for the EC2 instance(s)."
  type        = string
}

variable "instance_count" {
  description = "Number of instances to launch."
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID. If null, the latest Amazon Linux 2023 AMI is used."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch instances in (round-robin)."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of Security Group IDs to attach."
  type        = list(string)
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile name to attach."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script (base64-encoded or plain text)."
  type        = string
  default     = null
}

variable "root_volume_type" {
  description = "EBS volume type for the root device."
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Size in GiB for the root EBS volume."
  type        = number
  default     = 20
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
