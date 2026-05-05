# Module: Security Group

Creates an AWS Security Group with configurable ingress and a default allow-all egress rule.

## Usage

```hcl
module "web_sg" {
  source = "../../modules/security-group"

  name   = "myapp-dev-web"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { from_port = 80,  to_port = 80,  protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", description = "HTTP" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", description = "HTTPS" },
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name prefix | `string` | — | yes |
| description | SG description | `string` | `"Managed by Terraform"` | no |
| vpc_id | VPC ID | `string` | — | yes |
| ingress_rules | Ingress rules list | `list(object)` | `[]` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | Security Group ID |
| security_group_name | Security Group name |
