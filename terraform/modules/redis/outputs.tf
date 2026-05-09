output "redis_id" {
  description = "Redis Cache ID"
  value       = azurerm_redis_cache.this.id
}

output "redis_hostname" {
  description = "Redis Cache hostname"
  value       = azurerm_redis_cache.this.hostname
}

output "redis_port" {
  description = "Redis Cache SSL port"
  value       = azurerm_redis_cache.this.ssl_port
}

output "redis_primary_key" {
  description = "Redis Cache primary access key"
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
}

output "redis_connection_string" {
  description = "Redis Cache connection string"
  value       = azurerm_redis_cache.this.primary_connection_string
  sensitive   = true
}
