output "apim_id" {
  description = "API Management ID"
  value       = azurerm_api_management.this.id
}

output "apim_gateway_url" {
  description = "API Management gateway URL"
  value       = azurerm_api_management.this.gateway_url
}

output "apim_private_ip" {
  description = "API Management private IP address"
  value       = azurerm_api_management.this.private_ip_addresses
}

output "apim_identity_principal_id" {
  description = "System-assigned managed identity principal ID"
  value       = azurerm_api_management.this.identity[0].principal_id
}
