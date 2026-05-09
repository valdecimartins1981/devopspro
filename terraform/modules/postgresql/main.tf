resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.postgresql_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  version                = var.postgresql_version
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  sku_name               = var.sku_name
  storage_mb             = var.storage_mb
  backup_retention_days  = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup
  zone                   = "1"
  tags                   = var.tags

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgresql.id

  high_availability {
    mode                      = var.high_availability_mode
    standby_availability_zone = var.high_availability_mode == "ZoneRedundant" ? "2" : null
  }

  maintenance_window {
    day_of_week  = 0
    start_hour   = 2
    start_minute = 0
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgresql]
}

resource "azurerm_postgresql_flexible_server_configuration" "logging" {
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}

resource "azurerm_private_dns_zone" "postgresql" {
  name                = "${var.postgresql_name}.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "pdnslink-${var.postgresql_name}"
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
  tags                  = var.tags
}
