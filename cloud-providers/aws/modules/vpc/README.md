# Module: VPC

Creates a fully-featured VPC with:
- Public and private subnets spread across multiple Availability Zones
- Internet Gateway
- NAT Gateway (optional, one per AZ)
- Public and private Route Tables with associations

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name               = "myapp-dev"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  enable_nat_gateway = true

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Prefix name for all resources | `string` | — | yes |
| vpc_cidr | CIDR block for the VPC | `string` | `10.0.0.0/16` | no |
| availability_zones | List of AZs | `list(string)` | — | yes |
| public_subnet_cidrs | CIDR blocks for public subnets | `list(string)` | — | yes |
| private_subnet_cidrs | CIDR blocks for private subnets | `list(string)` | — | yes |
| enable_nat_gateway | Create NAT Gateway | `bool` | `true` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| vpc_cidr | VPC CIDR block |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| internet_gateway_id | Internet Gateway ID |
| nat_gateway_ids | List of NAT Gateway IDs |
