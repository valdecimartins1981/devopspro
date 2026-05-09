output "bastion_id" {
  description = "Bastion host ID"
  value       = azurerm_bastion_host.this.id
}

output "bastion_vm_id" {
  description = "Bastion management VM ID"
  value       = azurerm_linux_virtual_machine.bastion_vm.id
}

output "bastion_vm_private_ip" {
  description = "Bastion VM private IP address"
  value       = azurerm_network_interface.bastion_vm.private_ip_address
}
