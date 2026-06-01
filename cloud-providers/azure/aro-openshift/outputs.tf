output "cluster_name" {
  description = "Nome do cluster ARO"
  value       = azurerm_redhat_openshift_cluster.aro.name
}

output "api_server_url" {
  description = "URL do API Server do OpenShift"
  value       = azurerm_redhat_openshift_cluster.aro.api_server_profile[0].url
}

output "console_url" {
  description = "URL do Console Web do OpenShift"
  value       = azurerm_redhat_openshift_cluster.aro.console_url
}

output "resource_group" {
  description = "Resource Group do cluster"
  value       = azurerm_resource_group.aro.name
}

output "service_principal_client_id" {
  description = "Client ID do Service Principal"
  value       = azuread_application.aro.client_id
  sensitive   = true
}

output "sp_client_secret" {
  description = "Secret do Service Principal"
  value       = azuread_application_password.aro.value
  sensitive   = true
}

output "oc_login_command" {
  description = "Comando para login via CLI (requer kubeadmin password)"
  value       = "oc login ${azurerm_redhat_openshift_cluster.aro.api_server_profile[0].url} -u kubeadmin"
}
