output "priv_ip_address" {
  description = "The IP Address assigned to the main VM NIC"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "nic_id" {
  description = "the IP Address of the VM Network Interface"
  value       = azurerm_network_interface.vm_nic.id
}
