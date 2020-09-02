output "priv_ip_appdress" {
  description = "The IP Address assigned to the main VM NIC"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}
