locals {
  env_tags = merge(var.tags, {
    Environment = var.environment
  })
}

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "rg-${var.environment}-devopspro"
  location = var.location
  tags     = local.env_tags
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-${var.environment}-devopspro"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = var.vnet_address_space
  private_subnet_name = "snet-${var.environment}-private"
  private_subnet_prefixes = var.private_subnet_prefixes
  appgw_subnet_prefixes   = var.appgw_subnet_prefixes
  tags                = local.env_tags
}

module "automation" {
  source                  = "../../modules/automation"
  automation_account_name = "aa-${var.environment}-devopspro"
  environment             = var.environment
  location                = var.location
  resource_group_name     = module.resource_group.name
  aks_cluster_name        = module.aks.cluster_name
  aks_cluster_id          = module.aks.cluster_id
  tags                    = local.env_tags
}

module "aks" {
  source                     = "../../modules/aks"
  cluster_name               = "aks-${var.environment}-devopspro"
  location                   = var.location
  resource_group_name        = module.resource_group.name
  environment                = var.environment
  kubernetes_version         = var.kubernetes_version
  node_count                 = var.aks_node_count
  vm_size                    = "Standard_A2_v2"
  os_disk_size_gb            = 32
  subnet_id                  = module.vnet.private_subnet_id
  availability_zones         = ["1", "2"]
  enable_auto_scaling        = var.aks_enable_autoscaling
  min_node_count             = var.aks_min_nodes
  max_node_count             = var.aks_max_nodes
  log_analytics_workspace_id = module.automation.log_analytics_workspace_id
  tags                       = local.env_tags
}

module "container_registry" {
  source                   = "../../modules/container_registry"
  acr_name                 = "acrpreprddevopspro"
  resource_group_name      = module.resource_group.name
  location                 = var.location
  sku                      = "Premium"
  subnet_id                = module.vnet.private_subnet_id
  aks_kubelet_principal_id = module.aks.kubelet_identity[0].object_id
  tags                     = local.env_tags
}

module "redis" {
  source              = "../../modules/redis"
  redis_name          = "redis-${var.environment}-devopspro"
  location            = var.location
  resource_group_name = module.resource_group.name
  capacity            = 0
  family              = "C"
  sku_name            = "Standard"
  subnet_id           = module.vnet.private_subnet_id
  tags                = local.env_tags
}

module "postgresql" {
  source              = "../../modules/postgresql"
  postgresql_name     = "psql-${var.environment}-devopspro"
  location            = var.location
  resource_group_name = module.resource_group.name
  postgresql_version  = "15"
  admin_username      = var.postgresql_admin_username
  admin_password      = var.postgresql_admin_password
  sku_name            = var.postgresql_sku
  storage_mb          = var.postgresql_storage_mb
  backup_retention_days   = 14
  geo_redundant_backup    = var.postgresql_geo_redundant_backup
  high_availability_mode  = var.postgresql_ha_mode
  subnet_id           = module.vnet.private_subnet_id
  vnet_id             = module.vnet.vnet_id
  tags                = local.env_tags
}

module "key_vault" {
  source                    = "../../modules/key_vault"
  key_vault_name            = "kv-${var.environment}-devops"
  location                  = var.location
  resource_group_name       = module.resource_group.name
  sku_name                  = "standard"
  subnet_id                 = module.vnet.private_subnet_id
  aks_identity_principal_id = module.aks.cluster_identity_principal_id
  tags                      = local.env_tags
}

module "app_gateway" {
  source              = "../../modules/app_gateway"
  appgw_name          = "agw-${var.environment}-devopspro"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.vnet.appgw_subnet_id
  sku_name            = "WAF_v2"
  sku_tier            = "WAF_v2"
  capacity            = 2
  enable_waf          = true
  tags                = local.env_tags
}

module "api_management" {
  source              = "../../modules/api_management"
  apim_name           = "apim-${var.environment}-devopspro"
  location            = var.location
  resource_group_name = module.resource_group.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_tier            = "Developer"
  sku_capacity        = 1
  subnet_id           = module.vnet.private_subnet_id
  tags                = local.env_tags
}

module "front_door" {
  source              = "../../modules/front_door"
  frontdoor_name      = "afd-${var.environment}-devopspro"
  resource_group_name = module.resource_group.name
  sku_name            = "Standard_AzureFrontDoor"
  origin_host_name    = module.app_gateway.appgw_public_ip
  tags                = local.env_tags
}

module "bastion" {
  source                  = "../../modules/bastion"
  bastion_name            = "bas-${var.environment}-devopspro"
  location                = var.location
  resource_group_name     = module.resource_group.name
  vnet_name               = module.vnet.vnet_name
  bastion_subnet_prefixes = var.bastion_subnet_prefixes
  private_subnet_id       = module.vnet.private_subnet_id
  sku                     = "Standard"
  vm_size                 = "Standard_D2_v4"
  admin_username          = "azureuser"
  admin_ssh_public_key    = var.bastion_ssh_public_key
  tags                    = local.env_tags
}
