output "cluster_id" {
  description = "AKS cluster ID"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.this.name
}

output "kubelet_identity" {
  description = "Kubelet managed identity"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "kube_config" {
  description = "Kube config for kubectl"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "cluster_identity_principal_id" {
  description = "Cluster system-assigned identity principal ID"
  value       = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

output "node_resource_group" {
  description = "Resource group containing AKS node resources"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
