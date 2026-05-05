# Module: EKS

Creates an EKS cluster with:
- Cluster IAM role with `AmazonEKSClusterPolicy`
- Managed node group with required IAM policies
- Private API endpoint (public disabled by default)
- Full control plane logging

## Usage

```hcl
module "eks" {
  source = "../../modules/eks"

  cluster_name       = "myapp-dev"
  kubernetes_version = "1.29"

  subnet_ids      = module.vpc.private_subnet_ids
  node_subnet_ids = module.vpc.private_subnet_ids

  node_instance_types = ["t3.medium"]
  node_desired_size   = 2
  node_min_size       = 1
  node_max_size       = 4

  endpoint_private_access = true
  endpoint_public_access  = false

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | EKS cluster name | `string` | — | yes |
| kubernetes_version | Kubernetes version | `string` | `1.29` | no |
| subnet_ids | Control plane subnets | `list(string)` | — | yes |
| security_group_ids | Extra SG IDs | `list(string)` | `[]` | no |
| endpoint_private_access | Private API endpoint | `bool` | `true` | no |
| endpoint_public_access | Public API endpoint | `bool` | `false` | no |
| node_subnet_ids | Node group subnets | `list(string)` | — | yes |
| node_instance_types | Node instance types | `list(string)` | `[t3.medium]` | no |
| node_desired_size | Desired nodes | `number` | `2` | no |
| node_min_size | Minimum nodes | `number` | `1` | no |
| node_max_size | Maximum nodes | `number` | `4` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | Cluster ID |
| cluster_arn | Cluster ARN |
| cluster_endpoint | API server endpoint |
| cluster_certificate_authority_data | CA data |
| cluster_version | Kubernetes version |
| node_group_arn | Node group ARN |
