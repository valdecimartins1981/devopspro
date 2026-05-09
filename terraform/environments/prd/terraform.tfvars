environment            = "prd"
location               = "eastus2"
vnet_address_space     = ["10.40.0.0/16"]
private_subnet_prefixes = ["10.40.1.0/24"]
appgw_subnet_prefixes  = ["10.40.2.0/24"]
bastion_subnet_prefixes = ["10.40.3.0/26"]
kubernetes_version     = "1.28"

# AKS: 2 Clusters HA, 2 Nodes each (A2v2 - 2vCPU 4GB RAM - 32GB Disk)
aks_node_count         = 2
aks_min_nodes          = 2
aks_max_nodes          = 6

# PostgreSQL: DBMS com 80GB Disk, Zone Redundant HA
postgresql_sku         = "GP_Standard_D4s_v3"
postgresql_storage_mb  = 81920

apim_publisher_name    = "DevOpsPro"
apim_publisher_email   = "devops@company.com"

tags = {
  ManagedBy   = "Terraform"
  Project     = "DevOpsPro"
  Environment = "prd"
}
