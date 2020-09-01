variable "win_image_name" {
  description = "The name of the Azure VM Image to deploy from."
  type        = string
  default     = null
}

variable "location" {
  description = "The azure region where the new resource will be created"
  type        = string
}

variable "image_rg" {
  description = "The name of the Resource Group where the VM Image resides."
  type        = string
  default     = null
}

variable "rg_name" {
  description = "The name of the Resource Group where the new VM should be created."
  type        = string
}

variable "vm_vnet_name" {
  description = "The name of the vNET where the main Network interface of the new VM will be placed."
  type        = string
}

variable "vnet_rg_name" {
  description = "The name of the Resource Group where the vNEt resides."
  type        = string
}

variable "vm_subnet_name" {
  description = "The name of the Subnet where the main VM NIC will be added."
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VMs main NIC will reside"
}

variable "vm_name" {
  description = "The name to assign to the new VM"
  type        = string
}

variable "vm_size" {
  description = "The size of the new Vm to deploy. Options can be found HERE."
  default     = "standard_b2s"
  type        = string
}

variable "diagnostics_storage_account_name" {
  description = "The Storage account to use for VM diagnostics"
  type        = string
}

variable "admin_password" {
  description = "The password to assign to the new Admin user account."
  type        = string
}

variable "admin_username" {
  description = "The username to assign tot he new VMs admin user account"
  default     = "adminuser"
  type        = string
}

variable "tags" {
  description = "(optional) describe your variable"
  type        = map(string)
  default     = null
}

variable "storage_os_disk_config" {
  description = "Map to configure OS storage disk. (Caching, size, storage account type...)"
  type        = map(string)
  default = {
    disk_size_gb         = "30"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference"
  type        = map(string)

  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
