# Module: EC2

Creates one or more EC2 instances with IMDSv2 enforced, encrypted root volumes, and optional detailed monitoring.

## Usage

```hcl
module "app_server" {
  source = "../../modules/ec2"

  name               = "myapp-dev"
  instance_count     = 2
  instance_type      = "t3.small"
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.app_sg.security_group_id]

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Instance name tag | `string` | — | yes |
| instance_count | Number of instances | `number` | `1` | no |
| ami_id | AMI ID (null = latest AL2023) | `string` | `null` | no |
| instance_type | EC2 instance type | `string` | `t3.micro` | no |
| subnet_ids | Subnet IDs (round-robin) | `list(string)` | — | yes |
| security_group_ids | Security Group IDs | `list(string)` | — | yes |
| key_name | Key Pair name | `string` | `null` | no |
| iam_instance_profile | IAM Instance Profile | `string` | `null` | no |
| user_data | User data script | `string` | `null` | no |
| root_volume_type | Root EBS volume type | `string` | `gp3` | no |
| root_volume_size | Root EBS size (GiB) | `number` | `20` | no |
| enable_detailed_monitoring | CloudWatch detailed monitoring | `bool` | `false` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_ids | List of instance IDs |
| private_ips | List of private IPs |
| public_ips | List of public IPs |
