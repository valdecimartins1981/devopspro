##############################################################################
# Environment: UAT
# Calls all shared modules with UAT-appropriate settings.
##############################################################################

terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "uat"
      ManagedBy   = "Terraform"
      Project     = var.project_name
    }
  }
}

# ── Networking ────────────────────────────────────────────────────────────────
module "vpc" {
  source = "../../modules/vpc"

  name               = "${var.project_name}-uat"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = true

  tags = local.common_tags
}

# ── Security Groups ───────────────────────────────────────────────────────────
module "app_sg" {
  source = "../../modules/security-group"

  name   = "${var.project_name}-uat-app"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_ipv4 = var.vpc_cidr, description = "App port" },
  ]

  tags = local.common_tags
}

module "db_sg" {
  source = "../../modules/security-group"

  name   = "${var.project_name}-uat-db"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_ipv4 = var.vpc_cidr, description = "PostgreSQL" },
  ]

  tags = local.common_tags
}

# ── IAM ───────────────────────────────────────────────────────────────────────
module "app_role" {
  source = "../../modules/iam"

  name        = "${var.project_name}-uat"
  description = "Application role for ${var.project_name} UAT"

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

  tags = local.common_tags
}

# ── Compute ───────────────────────────────────────────────────────────────────
module "app_server" {
  source = "../../modules/ec2"

  name               = "${var.project_name}-uat"
  instance_count     = var.instance_count
  instance_type      = var.instance_type
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.app_sg.security_group_id]

  iam_instance_profile       = module.app_role.instance_profile_name
  enable_detailed_monitoring = true

  tags = local.common_tags
}

# ── Storage ───────────────────────────────────────────────────────────────────
module "app_bucket" {
  source = "../../modules/s3"

  bucket_name        = "${var.project_name}-uat-${var.aws_account_id}"
  versioning_enabled = true
  block_public_access = true

  tags = local.common_tags
}

# ── Database ──────────────────────────────────────────────────────────────────
module "db" {
  source = "../../modules/rds"

  identifier     = "${var.project_name}-uat"
  engine         = "postgres"
  engine_version = "15"
  instance_class = var.db_instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.db_sg.security_group_id]

  multi_az            = false
  deletion_protection = true
  skip_final_snapshot = false
  backup_retention_period = 7

  tags = local.common_tags
}

# ── Locals ────────────────────────────────────────────────────────────────────
locals {
  common_tags = {
    Environment = "uat"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
