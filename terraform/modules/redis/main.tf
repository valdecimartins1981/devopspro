resource "azurerm_redis_cache" "this" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  tags                = var.tags

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }
}

resource "azurerm_private_endpoint" "redis" {
  name                = "pe-${var.redis_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.redis_name}"
    private_connection_resource_id = azurerm_redis_cache.this.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }
}
