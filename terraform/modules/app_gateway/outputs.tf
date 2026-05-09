output "appgw_id" {
  description = "Application Gateway ID"
  value       = azurerm_application_gateway.this.id
}

output "appgw_public_ip" {
  description = "Application Gateway public IP"
  value       = azurerm_public_ip.appgw.ip_address
}

output "appgw_backend_pool_id" {
  description = "Application Gateway backend pool ID"
  value       = tolist(azurerm_application_gateway.this.backend_address_pool)[0].id
}
