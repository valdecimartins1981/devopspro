##############################################################################
# Module: IAM
# Creates IAM roles and attaches inline or managed policies.
##############################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# ── IAM Role ─────────────────────────────────────────────────────────────────
resource "aws_iam_role" "this" {
  name               = "${var.name}-role"
  path               = var.path
  description        = var.description
  assume_role_policy = var.assume_role_policy

  tags = merge(var.tags, {
    Name = "${var.name}-role"
  })
}

# ── Managed Policy Attachments ────────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# ── Inline Policy ─────────────────────────────────────────────────────────────
resource "aws_iam_role_policy" "inline" {
  count = var.inline_policy_json != null ? 1 : 0

  name   = "${var.name}-inline"
  role   = aws_iam_role.this.id
  policy = var.inline_policy_json
}

# ── Instance Profile (optional) ───────────────────────────────────────────────
resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.name}-instance-profile"
  role = aws_iam_role.this.name

  tags = var.tags
}
