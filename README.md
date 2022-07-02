# terraform-azurerm-windows-vm
Deploy a Windows Virtual Machine to Azure

## Provider
v3.0.0 of this module has been tested with v3.12.0 of the azurerm provider.

## Arguments
| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `resource_group_name` | `string` | true | The name of the Resource group where the new VM will be deployed. |
| `location` | `string` | true| The Azure Region where the VM will be deployed. |
| `vm_name` | `string` | true | The name to assign to the new Virtual machine. |
| `subnet_id` | `string` | true | The ID of the Azure Subnet where the main NIC of the VM will be created. |
| `vm_size` | `string` | false | The size of the VM to deploy. Defaults to Standard_B2s |
| `boot_diagnostics_storage_account_name` | `string` | false | The name of the storage account to use for VM Boot diagnostics. |
| `admin_username` | `string` | true | The username for the Admin User Account. |
| `admin_password` | `string` | true | The password to assign to the new Admin username. Please generate a password using a secure method.|
| `storage_os_disk_config` | `map` | false | A map object defining the `system` disk (see example below). |
| `marketplace_image` | `bool` | false | Are you deploying a VM image from the Azure Marketplace? If so, then `vm_image_plan` should also be set.|
| `vm_image` | `map` | false | A map object defining the VM image to deploy (see example below). |
| `vm_image_plan` | `map` | false | A map object defining the `plan` if deploying a Marketplace image (see exmaple below). |
| `source_image_id` | `string` | false | An ID of a Custom Image if deploying a custom VM Image. |
| `provision_vm_agent` | `bool` | false | Boolean value. Should the Azure VM Agent be installed in the VM. Defaults to `true`. |
| `enable_automatic_updates` | `bool` | false | Boolean value. Should automatic updates be enabled. Defaults to `true`. |
| `tags` | `map` | false | A map of key:value pairs to be applied to the VM as `tags` |

### storage_os_disk_config example

```js
 storage_os_disk_config = {
        disk_size_gb         = "200"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
```


### vm_image_plan example

```js
    vm_image_plan = {
      name      = "cis-ws2019-l1"
      product   = "cis-windows-server-2019-v1-0-0-l1"
      publisher = "center-for-internet-security-inc"
    }

```

### vm_image example

```js
    vm_image = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter"
      version   = "latest"
    }

```

## Example Usage

### Default Deployment
```js
module "windows-vm" {
  source  =
  version = "3.0.0"

  resource_group_name              = "rg-name"
  location                         = "uksouth"
  subnet_id                        = azurerm_subnet.subnet.id
  vm_name                          = "dev-default-01"
  admin_username                   = "adminuser"
  admin_password                   = "124Pa$$wYQd!H3!" # Never set passwords in this way. Use a password vault or other secrets engine to generate Passwords).
}
```

### Deploying A Custom VM Image with a Boot Diagnostic Storage Account

```js
module "windows-vm" {
  source  = 
  version = "3.0.0"

  resource_group_name              = "rg-name""
  location                         = "uksouth"
  subnet_id                        = azurerm_subnet.subnet.id
  vm_name                          = "dev-custom-01"
  source_image_id                  = local.image_id
  admin_username                   = "adminuser"
  admin_password                   = "124Pa$$wYQd!H3!" # Never set passwords in this way. Use a password vault or other secrets engine to generate Passwords).
  boot_diagnostics_storage_account_name = azurerm_storage_account.boot_diag.name

  tags = {
    Terraform   = true,
    environment = "DEV"
    image       = local.image_name
  }
}

```

### Deploying A Marketplace Image

```js
module "windows-vm" {
  source  = 
  version = "3.0.0"

  resource_group_name              = "rg-name"
  location                         = "uksouth"
  subnet_id                        = azurerm_subnet.subnet.id
  vm_name                          = "dev-cis-01"
  admin_username                   = "adminuser"
  admin_password                   = "124Pa$$wYQd!H3!" # Never set passwords in this way. For testing only. Use a password vault or random passwords.

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

```

### Deploying Multiple VMS Using `for_each` when calling the Module.

#### simple example

Simple example to loop through a list of VM Names, creating a new VM for each name in the list.

```js
locals {
  vms = ["vm1", "vm2", "vm3"]
}

module "windows-vm" {
  for_each = toset(local.vms)
  source  =
  version = "3.0.0"

  resource_group_name              = "rg-name"
  location                         = "uksouth"
  subnet_id                        = azurerm_subnet.subnet.id
  vm_name                          = each.value
  admin_username                   = "adminuser"
  admin_password                   = "124Pa$$wYQd!H3!" # Never set passwords in this way. Use a password vault or other secrets engine to generate Passwords).
}

```


