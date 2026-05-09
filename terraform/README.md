# DevOpsPro — Azure Infrastructure (Terraform)

This directory contains the complete Terraform code to provision the **DevOpsPro** Azure infrastructure across four environments: **DEV**, **QAS**, **PRE-PRD**, and **PRD**, all in the `eastus2` (US East 2) region.

---

## Architecture Overview

Each environment is provisioned with the following Azure resources, as defined in the architecture diagram:

| Component | Details |
|---|---|
| **Azure Front Door** | Global CDN + WAF entry point |
| **Resource Group** | Logical container per environment |
| **VNet + Subnets** | Private subnet + App Gateway subnet |
| **API Management** | Developer tier, VNet integrated, via Private Link |
| **Application Gateway** | WAF v2, private subnet |
| **AKS** | 1 cluster (DEV/QAS/PRE-PRD) · 2 clusters HA (PRD); 2 nodes, Standard_A2_v2, 32 GB disk |
| **Container Registry** | Premium SKU, private endpoint |
| **Redis Cache** | Standard C0 (250 MB) |
| **PostgreSQL Flexible Server** | 100 GB (DEV/QAS/PRE-PRD) · 80 GB Zone Redundant HA (PRD) |
| **Key Vault** | RBAC-enabled, private endpoint |
| **Azure Bastion + VM** | Standard Bastion host + Standard_D2_v4 management VM |
| **Automation Account** | Start/Stop runbooks for AKS node pools on schedule |
| **Log Analytics Workspace** | AKS monitoring |

### Network CIDR Allocation

| Environment | VNet | Private Subnet | AppGW Subnet | Bastion Subnet |
|---|---|---|---|---|
| DEV | 10.10.0.0/16 | 10.10.1.0/24 | 10.10.2.0/24 | 10.10.3.0/26 |
| QAS | 10.20.0.0/16 | 10.20.1.0/24 | 10.20.2.0/24 | 10.20.3.0/26 |
| PRE-PRD | 10.30.0.0/16 | 10.30.1.0/24 | 10.30.2.0/24 | 10.30.3.0/26 |
| PRD | 10.40.0.0/16 | 10.40.1.0/24 | 10.40.2.0/24 | 10.40.3.0/26 |

---

## Repository Structure

```
terraform/
├── providers.tf                  # Root provider config (optional, for root-level use)
├── variables.tf                  # Root variables
├── modules/
│   ├── resource_group/           # Azure Resource Group
│   ├── vnet/                     # VNet, private subnet, App Gateway subnet, NSG
│   ├── front_door/               # Azure Front Door (Standard/Premium) + WAF policy
│   ├── api_management/           # API Management (Developer tier) + Private Endpoint
│   ├── app_gateway/              # Application Gateway WAF v2 + Public IP
│   ├── aks/                      # AKS cluster + workload node pool
│   ├── container_registry/       # Azure Container Registry Premium + Private Endpoint
│   ├── redis/                    # Redis Cache Standard C0 + Private Endpoint
│   ├── postgresql/               # PostgreSQL Flexible Server + Private DNS Zone
│   ├── key_vault/                # Key Vault (RBAC) + Private Endpoint
│   ├── bastion/                  # Azure Bastion host + management VM (D2_v4)
│   └── automation/               # Automation Account + start/stop runbooks + Log Analytics
└── environments/
    ├── dev/                      # DEV environment (main.tf, variables.tf, providers.tf, *.tfvars)
    ├── qas/                      # QAS environment
    ├── pre-prd/                  # PRE-PRD environment
    └── prd/                      # PRD environment (2 HA AKS clusters, 80GB PostgreSQL)
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- Azure CLI authenticated: `az login`
- An Azure Storage Account for Terraform remote state (update `providers.tf` backend block in each environment)
- SSH public key for Bastion VM

---

## Usage

### 1. Deploy a specific environment

```bash
cd terraform/environments/dev   # or qas / pre-prd / prd

# Initialize with backend
terraform init

# Review the plan
terraform plan -var="postgresql_admin_password=<PASS>" \
               -var="bastion_ssh_public_key=<SSH_PUB_KEY>" \
               -var="apim_publisher_email=admin@company.com"

# Apply
terraform apply -var="postgresql_admin_password=<PASS>" \
                -var="bastion_ssh_public_key=<SSH_PUB_KEY>" \
                -var="apim_publisher_email=admin@company.com"
```

### 2. Sensitive variables

The following variables must be supplied at runtime (not stored in `terraform.tfvars`):

| Variable | Description |
|---|---|
| `postgresql_admin_password` | PostgreSQL administrator password |
| `bastion_ssh_public_key` | SSH public key for Bastion management VM |
| `postgresql_admin_username` | PostgreSQL admin username |

> **Recommended:** Store these in Azure Key Vault or use a CI/CD secret store and inject at pipeline run time.

---

## Key Design Decisions

- **Private networking:** All data services (PostgreSQL, Redis, Key Vault, ACR) use private endpoints or VNet service endpoints — no public access.
- **WAF protection:** Azure Front Door + Application Gateway both have WAF enabled with OWASP 3.2 ruleset.
- **RBAC-only Key Vault:** Key Vault uses Azure RBAC (`enable_rbac_authorization = true`) instead of legacy access policies.
- **AKS managed identity:** System-assigned managed identity for AKS with automatic ACR pull role and Key Vault Secrets User role.
- **PRD HA:** Production uses two AKS clusters (primary + secondary) and PostgreSQL Zone Redundant HA with geo-redundant backups.
- **Automation Start/Stop:** Azure Automation Account with PowerShell runbooks and weekday schedules (07:00 start / 20:00 stop, São Paulo timezone) to reduce costs in non-production environments.
