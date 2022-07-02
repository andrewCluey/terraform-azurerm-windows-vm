locals {
  source_image_id  = var.source_image_id != null ? var.source_image_id : false # is source_image_id variable set?
  boot_diagnostics = var.boot_diagnostics_storage_account_name != null ? var.boot_diagnostics_storage_account_name : false
}

# Create VM Network Interface
## Future enhancement - modify to allow static IP allocation
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

resource "azurerm_windows_virtual_machine" "vm" {
  name                     = var.vm_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  size                     = var.vm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  provision_vm_agent       = var.provision_vm_agent       # default is true
  enable_automatic_updates = var.enable_automatic_updates # default is true
  source_image_id          = var.source_image_id          # default is null
  tags                     = var.tags

  # If var.source_image_id = null (the default), then `source_image_reference` will be used.
  dynamic "source_image_reference" {
    for_each = local.source_image_id == "false" ? [1] : []
    content {
      offer     = lookup(var.vm_image, "offer", "WindowsServer")
      publisher = lookup(var.vm_image, "publisher", "MicrosoftWindowsServer")
      sku       = lookup(var.vm_image, "sku", "2019-Datacenter")
      version   = lookup(var.vm_image, "version", "latest")
    }
  }

  os_disk {
    name                   = lookup(var.storage_os_disk_config, "name", "${var.vm_name}-osdisk")
    caching                = lookup(var.storage_os_disk_config, "caching", "ReadWrite")
    storage_account_type   = lookup(var.storage_os_disk_config, "storage_account_type", "Standard_LRS")
    disk_size_gb           = lookup(var.storage_os_disk_config, "disk_size_gb", "127")
    disk_encryption_set_id = lookup(var.storage_os_disk_config, "disk_encryption_set_id", null)
  }

  # Set a boot diagnostic storage account ONLY if the `diagnostics_storage_account_name` input parameter is set.
  dynamic "boot_diagnostics" {
    for_each = local.boot_diagnostics == "false" ? [] : [1]
    content {
      storage_account_uri = "https://${var.boot_diagnostics_storage_account_name}.blob.core.windows.net"
    }
  }

  # Define a `plan` block ONLY if var.vm_image_plan has been defined.
  dynamic "plan" {
    for_each = var.marketplace_image == true ? [1] : []

    content {
      name      = var.vm_image_plan.name
      product   = var.vm_image_plan.product
      publisher = var.vm_image_plan.publisher
    }
  }

  ## future enhancement - allow this to be switched on/off
  identity {
    type = "SystemAssigned"
  }

  ## Future Enhancement - allow for multiple NICs to be added.
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]
}
