output "postgresql_id" {
  description = "PostgreSQL Flexible Server ID"
  value       = azurerm_postgresql_flexible_server.this.id
}

output "postgresql_fqdn" {
  description = "PostgreSQL Flexible Server FQDN"
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "postgresql_name" {
  description = "PostgreSQL Flexible Server name"
  value       = azurerm_postgresql_flexible_server.this.name
}
