output "priv_ip_address" {
  description = "The IP Address assigned to the main VM NIC"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "nic_id" {
  description = "the IP Address of the VM Network Interface"
  value       = azurerm_network_interface.vm_nic.id
}

output "vm_nsg_id" {
  description = "The ID of the Network Secyurity group that has been assigned to the VM"
  value       = azurerm_network_security_group.vm_nsg.id
}

output "vm_nsg_name" {
  description = "The name of the Network Secyurity group that has been assigned to the VM"
  value       = azurerm_network_security_group.vm_nsg.name
}
