data "azurerm_image" "win2019" {
  name                = "win2019-img-image-20220701"
  resource_group_name = "rg-images"
}

locals {
  image_name = data.azurerm_image.win2019.name
  image_id   = data.azurerm_image.win2019.id
}


module "windows-vm" { # deploy a custom image (source_image_id)
  source = "../../"

  resource_group_name                   = azurerm_resource_group.simple_rg.name
  location                              = azurerm_resource_group.simple_rg.location
  subnet_id                             = azurerm_subnet.subnet.id
  vm_name                               = "dev-custom-01"
  source_image_id                       = local.image_id
  admin_username                        = "adminuser"
  admin_password                        = "124Pa$$wYQd!H3!" # Never set passwords in this way. Use a password vault or other secrets engine to generate Passwords).
  boot_diagnostics_storage_account_name = azurerm_storage_account.boot_diag.name

  tags = {
    Terraform   = true,
    environment = "DEV"
    image       = local.image_name
  }
}


####################
# Required Resources
####################
resource "azurerm_resource_group" "simple_rg" {
  name     = "rg-test2-vm"
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

resource "azurerm_storage_account" "boot_diag" {
  name                     = "sadevasc01"
  resource_group_name      = azurerm_resource_group.simple_rg.name
  location                 = azurerm_resource_group.simple_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}