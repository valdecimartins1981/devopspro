environment            = "pre-prd"
location               = "eastus2"
vnet_address_space     = ["10.30.0.0/16"]
private_subnet_prefixes = ["10.30.1.0/24"]
appgw_subnet_prefixes  = ["10.30.2.0/24"]
bastion_subnet_prefixes = ["10.30.3.0/26"]
kubernetes_version     = "1.28"

# AKS: 1 Cluster, 2 Nodes (A2v2 - 2vCPU 4GB RAM - 32GB Disk)
aks_node_count         = 2
aks_enable_autoscaling = true
aks_min_nodes          = 2
aks_max_nodes          = 5

# PostgreSQL: DBMS com 100GB Disk
postgresql_sku         = "GP_Standard_D2s_v3"
postgresql_storage_mb  = 102400
postgresql_ha_mode     = "SameZone"

apim_publisher_name    = "DevOpsPro"
apim_publisher_email   = "devops@company.com"

tags = {
  ManagedBy   = "Terraform"
  Project     = "DevOpsPro"
  Environment = "pre-prd"
}
