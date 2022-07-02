locals {
  vms = ["vm1", "vm2", "vm3"]
}

module "windows-vm" { # deploy default values
  for_each = toset(local.vms)
  source   = "../../"

  resource_group_name = azurerm_resource_group.simple_rg.name
  location            = azurerm_resource_group.simple_rg.location
  subnet_id           = azurerm_subnet.subnet.id
  vm_name             = each.value
  admin_username      = "adminuser"
  admin_password      = "124Pa$$wYQd!H3!" # Never set passwords in this way. Use a password vault or other secrets engine to generate Passwords).
}

####################
# Required Resources
####################
resource "azurerm_resource_group" "simple_rg" {
  name     = "rg-test-vm"
  location = "uksouth"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vn-test-vm"
  address_space       = ["172.25.8.0/23"]
  location            = azurerm_resource_group.simple_rg.location
  resource_group_name = azurerm_resource_group.simple_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "sn-test-vm-a"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.25.8.0/24"]
  resource_group_name  = azurerm_resource_group.simple_rg.name
}
