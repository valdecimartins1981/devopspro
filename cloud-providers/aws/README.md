# AWS Terraform Modules

> Reusable Terraform modules for AWS, organized by environment and compatible with IDP platforms (Backstage, Port.io).

## Directory Structure

```
cloud-providers/aws/
├── modules/                        # Reusable building blocks
│   ├── vpc/                        # VPC, subnets, IGW, NAT, route tables
│   ├── ec2/                        # EC2 instances (IMDSv2, encrypted EBS)
│   ├── s3/                         # S3 bucket (versioning, SSE, lifecycle)
│   ├── rds/                        # RDS instance with DB Subnet Group
│   ├── eks/                        # EKS cluster + managed node group
│   ├── iam/                        # IAM role, policies, instance profile
│   └── security-group/             # Security Group with flexible rules
│
├── environments/
│   ├── dev/                        # DEV: 1 AZ, t3.small EC2, db.t3.micro
│   ├── uat/                        # UAT: 2 AZ, t3.medium EC2, db.t3.small
│   └── prod/                       # PROD: 3 AZ, EKS, Multi-AZ RDS
│
├── catalog-info.yaml               # Backstage IDP catalog entries
└── .port/entity.json               # Port.io IDP entity definition
```

## Environment Summary

| Setting | DEV | UAT | PROD |
|---------|-----|-----|------|
| AZs | 2 | 2 | 3 |
| Compute | EC2 (t3.small ×1) | EC2 (t3.medium ×2) | EKS (m5.large ×3) |
| RDS class | db.t3.micro | db.t3.small | db.r6g.large |
| Multi-AZ RDS | ✗ | ✗ | ✓ |
| Deletion protection | ✗ | ✓ | ✓ |
| Backup retention | 3 days | 7 days | 14 days |
| NAT Gateway | ✓ | ✓ | ✓ |

## Quick Start

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.6
- AWS CLI configured (`aws configure`)
- An S3 bucket + DynamoDB table for remote state (see below)

### Bootstrap Remote State

```bash
# Create state bucket (one-time, per AWS account)
aws s3api create-bucket --bucket myapp-terraform-state --region us-east-1
aws s3api put-bucket-versioning \
  --bucket myapp-terraform-state \
  --versioning-configuration Status=Enabled

# Create DynamoDB lock table
aws dynamodb create-table \
  --table-name myapp-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Deploy an Environment

```bash
cd environments/dev

# Copy and edit example vars
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with real values

# Initialize with remote backend
terraform init -backend-config=backend.hcl

# Preview changes
terraform plan

# Apply
export TF_VAR_db_password="<your-secret>"
terraform apply
```

### Modules

Each module under `modules/` is self-contained and has its own `README.md` with usage examples.

| Module | Description |
|--------|-------------|
| [vpc](./modules/vpc/README.md) | VPC with public/private subnets, IGW, NAT |
| [ec2](./modules/ec2/README.md) | EC2 instances with IMDSv2 |
| [s3](./modules/s3/README.md) | S3 with encryption & lifecycle |
| [rds](./modules/rds/README.md) | RDS with subnet group & backups |
| [eks](./modules/eks/README.md) | EKS cluster + managed node group |
| [iam](./modules/iam/README.md) | IAM role, policies, instance profile |
| [security-group](./modules/security-group/README.md) | Security Groups |

## IDP Integration

### Backstage

Register the component by adding the catalog URL to your Backstage `app-config.yaml`:

```yaml
catalog:
  locations:
    - type: url
      target: https://github.com/valdecimartins1981/devopspro/blob/main/cloud-providers/aws/catalog-info.yaml
```

### Port.io

Import the entity from `.port/entity.json` via the Port CLI or API:

```bash
port-cli entities upsert --file .port/entity.json --blueprint infrastructure
```

## Security Notes

- **Secrets**: Never commit `terraform.tfvars` with passwords. Use `TF_VAR_*` environment variables or AWS Secrets Manager.
- **Remote state**: The S3 backend is configured with encryption enabled.
- **IMDSv2**: EC2 instances enforce IMDSv2 (`http_tokens = "required"`).
- **EBS encryption**: Root volumes are encrypted at rest.
- **RDS encryption**: Storage encryption is always enabled.
