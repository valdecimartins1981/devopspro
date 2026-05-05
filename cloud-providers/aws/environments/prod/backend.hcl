bucket         = "myapp-terraform-state"
key            = "aws/prod/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "myapp-terraform-locks"
