# ── Remote state backend for DEV ─────────────────────────────────────────────
# Use this file with: terraform init -backend-config=backend.hcl
# The bucket and DynamoDB table must be pre-created (bootstrap step).

bucket         = "myapp-terraform-state"
key            = "aws/dev/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "myapp-terraform-locks"
