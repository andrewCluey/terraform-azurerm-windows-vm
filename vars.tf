variable "win_image_name" {
  description = "The name of the Azure VM Image to deploy from."
  type        = string
  default     = null
}

variable "image_rg" {
  description = "The name of the Resource Group where the VM Image resides."
  type        = string
  default     = null
}

variable "location" {
  description = "The azure region where the new resource will be created"
  type        = string
}

variable "rg_name" {
  description = "The name of the Resource Group where the new VM should be created."
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VMs main NIC will reside"
}

variable "is_custom_image" {
  description = "Is the VM deployed from a custom image? True/False"
  type        = bool
  default     = false
}

variable "image_id" {
  description = "If deploying a custom VM Image, enter in the the ID of the VM image in this param."
  type        = string
  default     = null
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
    disk_size_gb         = "127" # minimum disk size of 127GB
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

variable "plan" {
  description = "A Plan block to be used when the source VM image was taken from a marketplace image (Required data will be tagged on to the VM Image.)"
  type        = map(string)
  default     = null
}
