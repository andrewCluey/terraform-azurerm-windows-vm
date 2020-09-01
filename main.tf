provider "azurerm" {
  version = "=2.25.0"
  features {}
}

# DATA LOOKUPS

# Get VM image Details
data "azurerm_image" "win_image" {
  name                = var.win_image_name
  resource_group_name = var.image_rg
}

# Get Resource Group
#data "azurerm_resource_group" "vm_rg" {
#  name = var.vm_rg
#}

# Get Azure vNET Details
#data "azurerm_virtual_network" "vm_vnet" {
#  name                = var.vm_vnet_name
#  resource_group_name = var.vnet_rg_name
#}

# Get Azure Subnet details
#data "azurerm_subnet" "vm_subnet" {
#  name                 = var.vm_subnet_name
#  virtual_network_name = data.azurerm_virtual_network.vm_vnet.name
#  resource_group_name  = var.vnet_rg_name
#}

# CREATE RESOURCES

# Create VM Network Interfaces
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location #data.azurerm_resource_group.vm_rg.location
  resource_group_name = var.rg_name  # data.azurerm_resource_group.vm_rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.vm_name}-ip"
    subnet_id                     = var.subnet_id # data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Create VM
resource "azurerm_windows_virtual_machine" "win_vm" {
  # count if true conditional
  count               = var.win_image_name ? 1 : 0
  name                = var.vm_name
  location            = var.location # data.azurerm_resource_group.vm_rg.location
  resource_group_name = var.rg_name  # data.azurerm_resource_group.vm_rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  source_image_id     = data.azurerm_image.win_image.id
  tags                = var.tags

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  os_disk {
    name                 = lookup(var.storage_os_disk_config, "name", "${var.vm_name}-osdisk")
    caching              = lookup(var.storage_os_disk_config, "caching", null)
    storage_account_type = lookup(var.storage_os_disk_config, "storage_account_type", null)
    disk_size_gb         = lookup(var.storage_os_disk_config, "disk_size_gb", null)
  }

  identity {
    type = "SystemAssigned"
  }

}


# If not Custom image, Deploy Image from marketplace. DEFAULT Windows Server 2019 Datacenter
resource "azurerm_windows_virtual_machine" "vm" {
  count                    = var.win_image_name ? 0 : 1
  name                     = var.vm_name
  location                 = var.location # data.azurerm_resource_group.vm_rg.location
  resource_group_name      = var.rg_name  # data.azurerm_resource_group.vm_rg.name
  size                     = var.vm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  provision_vm_agent       = true
  enable_automatic_updates = true
  tags                     = var.tags

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  source_image_reference {
    offer     = lookup(var.vm_image, "offer", null)
    publisher = lookup(var.vm_image, "publisher", null)
    sku       = lookup(var.vm_image, "sku", null)
    version   = lookup(var.vm_image, "version", null)
  }

  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  os_disk {
    name                 = lookup(var.storage_os_disk_config, "name", "${var.vm_name}-osdisk")
    caching              = lookup(var.storage_os_disk_config, "caching", null)
    storage_account_type = lookup(var.storage_os_disk_config, "storage_account_type", null)
    disk_size_gb         = lookup(var.storage_os_disk_config, "disk_size_gb", null)
  }

  identity {
    type = "SystemAssigned"
  }
}

