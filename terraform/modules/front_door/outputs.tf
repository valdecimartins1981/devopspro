output "frontdoor_id" {
  description = "Front Door profile ID"
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "frontdoor_endpoint_hostname" {
  description = "Front Door endpoint hostname"
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}
