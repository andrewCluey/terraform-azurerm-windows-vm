module "windows-vm" {
  source = "../../"

  resource_group_name = azurerm_resource_group.simple_rg.name
  location            = azurerm_resource_group.simple_rg.location
  subnet_id           = azurerm_subnet.subnet.id
  vm_name             = "dev-cis-02"
  admin_username      = "adminuser"
  admin_password      = "124Pa$$wYQd!H3!" # Never set passwords in this way. For testing only. Use a password vault or random passwords.
  marketplace_image   = true

  vm_image = {
    publisher = "center-for-internet-security-inc"
    offer     = "cis-windows-server-2019-v1-0-0-l1"
    sku       = "cis-ws2019-l1"
    version   = "latest"
  }

  vm_image_plan = {
    name      = "cis-ws2019-l1"
    product   = "cis-windows-server-2019-v1-0-0-l1"
    publisher = "center-for-internet-security-inc"
  }

  tags = {
    Terraform   = true,
    environment = "DEV"
  }
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