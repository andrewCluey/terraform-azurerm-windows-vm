# terraform-azurerm-windows-vm
Deploy a Windows Virtual Machine to Azure

## Example Usage

```hcl
resource "azurerm_resource_group" "test_rg" {
  name     = "rg-test-vm-tf-deploy"
  location = "West Europe"
}

resource "azurerm_vnet" "vnet" {
    name           = "vn-test-win-deploy"
    address_space  = ["172.25.8.0/23"]
    location       = azurerm_resource_group.test_rg.location
    resource_group = azurerm_resource_group.test_rg.name
}

resource "azurerm_subnet "subnet" {
    name                 = "sn-test-win-deploy-a"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["172.25.8.0/24]
    resource_group       = azurerm_resource_group.test_rg.name
}

resource "azurerm_storage_account" "sa-test" {
  name                     = "sa-test-01"
  resource_group_name      = azurerm_resource_group.test_rg.name
  location                 = azurerm_resource_group.test_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

module "windows-vm" {
  source  = "andrewCluey/windows-vm/azurerm"
  version = "0.0.3"
  # insert the 10 required variables here
  
  vm_rg                            = azurerm_resource_group.test_rg.name
  win_image_name                   = "prebuilt_winimage"
  image_rg                         = "rg-vm-images"
  vnet_rg_name                     = "privateendpoint-vnet-resourcegroup"
  vm_subnet                        = "privateendpoint-subnet-name"
  vm_vnet_name                     = "privateendpoint-vnet-name"
  vm_name                          = "asc-testvm-01"
  admin_username                   = "adminuser"
  admin_password                   = "124Pa$$wYQd!H3!"
  diagnostics_storage_account_name = azurerm_storage_account.sa-test.name

  tags = { 
      Terraform = true,
      environment = "DEV"
      }
}

```


## Arguments
| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `win_image_name` | `string` | true | The name of the Custom Azure VM Image that the new VM should be deployed from. |
| | | | |