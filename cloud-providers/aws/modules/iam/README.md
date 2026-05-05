# Module: IAM

Creates an IAM Role with optional managed policy attachments, an inline policy, and an optional Instance Profile.

## Usage

```hcl
module "app_role" {
  source = "../../modules/iam"

  name        = "myapp-dev"
  description = "Application role for myapp DEV"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  create_instance_profile = true

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Base name for resources | `string` | — | yes |
| path | IAM path | `string` | `/` | no |
| description | Role description | `string` | `"Managed by Terraform"` | no |
| assume_role_policy | Trust policy JSON | `string` | — | yes |
| managed_policy_arns | Managed policy ARNs | `list(string)` | `[]` | no |
| inline_policy_json | Inline policy JSON | `string` | `null` | no |
| create_instance_profile | Create Instance Profile | `bool` | `false` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | Role ARN |
| role_name | Role name |
| instance_profile_arn | Instance Profile ARN |
| instance_profile_name | Instance Profile name |
