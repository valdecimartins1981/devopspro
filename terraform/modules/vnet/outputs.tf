output "vnet_id" {
  description = "Virtual network ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.this.name
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = azurerm_subnet.private.id
}

output "appgw_subnet_id" {
  description = "App Gateway subnet ID"
  value       = azurerm_subnet.appgw.id
}
