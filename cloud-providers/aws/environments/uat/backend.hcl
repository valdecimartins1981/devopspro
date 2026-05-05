bucket         = "myapp-terraform-state"
key            = "aws/uat/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "myapp-terraform-locks"
