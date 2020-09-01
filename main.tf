# DATA LOOKUPS

# Get VM image Details
data "azurerm_image" "win_image" {
  name                = var.win_image_name
  resource_group_name = var.image_rg
}

# Get Resource Group
data "azurerm_resource_group" "vm_rg" {
  name = var.vm_rg
}

# Get Azure vNET Details
data "azurerm_virtual_network" "vm_vnet" {
  name                = var.vm_vnet_name
  resource_group_name = var.vnet_rg_name
}

# Get Azure Subnet details
data "azurerm_subnet" "vm_subnet" {
  name                 = var.vm_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vm_net.name
  resource_group_name  = var.vnet_rg_name
}


# CREATE RESOURCES

# Create VM Network Interfaces
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.vm_name}-ip"
    subnet_id                     = data.azurerm_subnet.vm_subnet_name.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Create VM
resource "azurerm_windows_virtual_machine" "win_vm" {
  name                = var.vm_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.password
  source_image_id     = data.azurerm_image.win_image.id
  tags                = var.tags

  network_interface_ids = [
    data.azurerm_network_interface.vm_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

