locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  default_tags = {
    environment   = var.environment
    "cost centre" = var.project_code
  }

  tags = merge(var.tags, local.module_tag, local.default_tags)
}


# Create VM Network Interface
## Future enhancement - modify this to include option to deploy mutliple NICs via 'for_each'
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.vm_name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# If 'is_custom_image' = true. Create Custom VM
resource "azurerm_windows_virtual_machine" "win_vm" {
  count               = var.is_custom_image ? 1 : 0
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  source_image_id     = var.image_id
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


# If 'is_custom_image' = false. Create VM from standard image. DEFAULT Windows Server 2019 Datacenter.
resource "azurerm_windows_virtual_machine" "vm" {
  count                    = var.is_custom_image ? 0 : 1
  name                     = var.vm_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
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
