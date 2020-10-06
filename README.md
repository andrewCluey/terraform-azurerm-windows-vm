# terraform-azurerm-windows-vm
Deploy a Windows Virtual Machine to Azure

## Example Usage

### Deploying a standard Windows VM Image
```hcl
provider "azurerm" {
  version = "=2.25.0"
  features {}
}

resource "azurerm_resource_group" "test_rg" {
  name     = "rg-test-vm-tf-deploy"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
    name                = "vn-test-win-deploy"
    address_space       = ["172.25.8.0/23"]
    location            = azurerm_resource_group.test_rg.location
    resource_group_name = azurerm_resource_group.test_rg.name
}

resource "azurerm_subnet" "subnet" {
    name                 = "sn-test-win-deploy-a"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["172.25.8.0/24"]
    resource_group_name  = azurerm_resource_group.test_rg.name
}

resource "azurerm_storage_account" "sa-test" {
  name                     = "satestasc01"
  resource_group_name      = azurerm_resource_group.test_rg.name
  location                 = azurerm_resource_group.test_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

module "windows-vm" {
  source  = "andrewCluey/windows-vm/azurerm"
  version = "0.0.15"
  # insert the 10 required variables here
  
  is_custom_image                  = false
  rg_name                          = azurerm_resource_group.test_rg.name
  location                         = azurerm_resource_group.test_rg.location
  subnet_id                        = azurerm_subnet.subnet.id
  vm_name                          = "asc-testvm-01"
  admin_username                   = "adminuser"
  admin_password                   = "124Pa$$wYQd!H3!"
  diagnostics_storage_account_name = azurerm_storage_account.sa-test.name
  
  storage_os_disk_config = {
    disk_size_gb         = "127"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  vm_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = { 
      Terraform = true,
      environment = "DEV"
      }
}
```

### Deploying a custom VM Image

```hcl
provider "azurerm" {
  version = "=2.25.0"
  features {}
}

resource "azurerm_resource_group" "test_rg" {
  name     = "rg-test-vm-tf-deploy"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
    name                = "vn-test-win-deploy"
    address_space       = ["172.25.8.0/23"]
    location            = azurerm_resource_group.test_rg.location
    resource_group_name = azurerm_resource_group.test_rg.name
}

resource "azurerm_subnet" "subnet" {
    name                 = "sn-test-win-deploy-a"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["172.25.8.0/24"]
    resource_group_name  = azurerm_resource_group.test_rg.name
}

resource "azurerm_storage_account" "sa-test" {
  name                     = "satestasc01"
  resource_group_name      = azurerm_resource_group.test_rg.name
  location                 = azurerm_resource_group.test_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

data "azurerm_image" "win_image" {
  name                = "custom-win2019-image"
  resource_group_name = "rg-vm-images"
}

module "windows-vm" {
  source  = "andrewCluey/windows-vm/azurerm"
  version = "0.0.15"
  # insert the 10 required variables here
  
  is_custom_image                  = true
  rg_name                          = azurerm_resource_group.test_rg.name
  location                         = azurerm_resource_group.test_rg.location
  subnet_id                        = azurerm_subnet.subnet.id
  vm_name                          = "asc-testvm-01"
  image_id                         = data.azurerm_image.win_image.id
  admin_username                   = "adminuser"
  admin_password                   = "124Pa$$wYQd!H3!"
  diagnostics_storage_account_name = azurerm_storage_account.sa-test.name
  
  storage_os_disk_config = {
    disk_size_gb         = "127"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  plan = {
    name      = "cis-ws2019-l2"
    product   = "cis-windows-server-2019-v1-0-0-l2"
    publisher = "center-for-internet-security-inc"
  }

  tags = { 
      Terraform = true,
      environment = "DEV"
      }
}
```
## Arguments
| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `is_custom_image` | `bool` | true | Defaults to `false`. Defines whether a custom image is to be used to deploy the VM or not. | 
| `image_id` | `string` | false | If deploying from a custom VM Image. The ID of the Custom Azure VM Image the new VM should be deployed from. |
| `rg_name` | `string` | true | The name of the Resource group where the new VM will be deployed. |
| `location` | `string` | true| The Azure Region where the VM will be deployed. |
| `subnet_id` | `string` | true | The ID of the Azure Subnet where the main NIC of the VM will be created. |
| `vm_name` | `string` | true | The name to assign to the new Virtual machine. |
| `admin_username` | `string` | true | The username for the Admin User Account. |
| `admin_password` | `string` | true | The password to assign to the new Admin username. |
| `diagnostics_storage_account_name` | `string` | true | The storage account to use for VM Boot diagnostics. |