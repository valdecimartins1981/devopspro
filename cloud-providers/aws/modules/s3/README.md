# Module: S3

Creates an S3 bucket with versioning, AES-256 server-side encryption, public access block, and optional lifecycle rules.

## Usage

```hcl
module "app_bucket" {
  source = "../../modules/s3"

  bucket_name        = "myapp-dev-assets-123456"
  versioning_enabled = true
  block_public_access = true

  lifecycle_rules = [
    {
      id     = "archive-old-objects"
      prefix = "logs/"
      transitions = [
        { days = 30,  storage_class = "STANDARD_IA" },
        { days = 90,  storage_class = "GLACIER" },
      ]
      expiration_days = 365
    }
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
| bucket_name | Globally unique bucket name | `string` | — | yes |
| versioning_enabled | Enable versioning | `bool` | `true` | no |
| force_destroy | Allow destroy with objects | `bool` | `false` | no |
| block_public_access | Block all public access | `bool` | `true` | no |
| lifecycle_rules | Lifecycle rule objects | `list(object)` | `[]` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | Bucket name/ID |
| bucket_arn | Bucket ARN |
| bucket_domain_name | Bucket domain name |
