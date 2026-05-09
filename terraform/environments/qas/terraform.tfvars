environment            = "qas"
location               = "eastus2"
vnet_address_space     = ["10.20.0.0/16"]
private_subnet_prefixes = ["10.20.1.0/24"]
appgw_subnet_prefixes  = ["10.20.2.0/24"]
bastion_subnet_prefixes = ["10.20.3.0/26"]
kubernetes_version     = "1.28"

# AKS: 1 Cluster, 2 Nodes (A2v2 - 2vCPU 4GB RAM - 32GB Disk)
aks_node_count         = 2
aks_enable_autoscaling = true
aks_min_nodes          = 2
aks_max_nodes          = 4

# PostgreSQL: DBMS com 100GB Disk
postgresql_sku         = "B_Standard_B1ms"
postgresql_storage_mb  = 102400
postgresql_ha_mode     = "Disabled"

apim_publisher_name    = "DevOpsPro"
apim_publisher_email   = "devops@company.com"

tags = {
  ManagedBy   = "Terraform"
  Project     = "DevOpsPro"
  Environment = "qas"
}
