# Module: RDS

Creates an RDS database instance with a DB Subnet Group, encrypted storage, automated backups, and optional Multi-AZ.

> **Security note:** The `password` variable is marked `sensitive`. Use AWS Secrets Manager or SSM Parameter Store to retrieve the value and avoid hardcoding credentials.

## Usage

```hcl
module "db" {
  source = "../../modules/rds"

  identifier    = "myapp-dev"
  engine        = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"

  db_name  = "appdb"
  username = "dbadmin"
  password = var.db_password   # pass via tfvars or Secrets Manager

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.db_sg.security_group_id]

  multi_az            = false
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| identifier | RDS identifier | `string` | — | yes |
| engine | DB engine | `string` | `postgres` | no |
| engine_version | Engine version | `string` | `15` | no |
| instance_class | Instance class | `string` | `db.t3.micro` | no |
| allocated_storage | Storage in GiB | `number` | `20` | no |
| db_name | Initial database name | `string` | — | yes |
| username | Master username | `string` | — | yes |
| password | Master password (sensitive) | `string` | — | yes |
| port | DB port | `number` | `5432` | no |
| subnet_ids | Subnet IDs | `list(string)` | — | yes |
| security_group_ids | Security Group IDs | `list(string)` | — | yes |
| backup_retention_period | Backup retention days | `number` | `7` | no |
| multi_az | Multi-AZ deployment | `bool` | `false` | no |
| deletion_protection | Enable deletion protection | `bool` | `true` | no |
| skip_final_snapshot | Skip final snapshot | `bool` | `false` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | Instance identifier |
| db_instance_endpoint | Connection endpoint |
| db_instance_arn | Instance ARN |
| db_subnet_group_name | DB Subnet Group name |
