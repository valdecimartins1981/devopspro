##############################################################################
# Environment: PROD
# Calls all shared modules with production-grade settings:
#   - Multi-AZ RDS
#   - Deletion protection enabled
#   - EKS cluster instead of plain EC2
#   - 3 AZs
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
      Environment = "prod"
      ManagedBy   = "Terraform"
      Project     = var.project_name
    }
  }
}

# ── Networking ────────────────────────────────────────────────────────────────
module "vpc" {
  source = "../../modules/vpc"

  name               = "${var.project_name}-prod"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = true

  tags = local.common_tags
}

# ── Security Groups ───────────────────────────────────────────────────────────
module "eks_sg" {
  source = "../../modules/security-group"

  name   = "${var.project_name}-prod-eks"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_ipv4 = var.vpc_cidr, description = "Kubernetes API" },
  ]

  tags = local.common_tags
}

module "db_sg" {
  source = "../../modules/security-group"

  name   = "${var.project_name}-prod-db"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_ipv4 = var.vpc_cidr, description = "PostgreSQL" },
  ]

  tags = local.common_tags
}

# ── Compute — EKS ─────────────────────────────────────────────────────────────
module "eks" {
  source = "../../modules/eks"

  cluster_name       = "${var.project_name}-prod"
  kubernetes_version = var.kubernetes_version

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.eks_sg.security_group_id]
  node_subnet_ids    = module.vpc.private_subnet_ids

  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size

  endpoint_private_access = true
  endpoint_public_access  = false

  tags = local.common_tags
}

# ── Storage ───────────────────────────────────────────────────────────────────
module "app_bucket" {
  source = "../../modules/s3"

  bucket_name        = "${var.project_name}-prod-${var.aws_account_id}"
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

  tags = local.common_tags
}

# ── Database ──────────────────────────────────────────────────────────────────
module "db" {
  source = "../../modules/rds"

  identifier     = "${var.project_name}-prod"
  engine         = "postgres"
  engine_version = "15"
  instance_class = var.db_instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.db_sg.security_group_id]

  multi_az            = true
  deletion_protection = true
  skip_final_snapshot = false
  backup_retention_period = 14

  tags = local.common_tags
}

# ── Locals ────────────────────────────────────────────────────────────────────
locals {
  common_tags = {
    Environment = "prod"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
