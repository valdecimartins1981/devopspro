output "acr_id" {
  description = "Container Registry ID"
  value       = azurerm_container_registry.this.id
}

output "acr_login_server" {
  description = "Container Registry login server URL"
  value       = azurerm_container_registry.this.login_server
}

output "acr_name" {
  description = "Container Registry name"
  value       = azurerm_container_registry.this.name
}
