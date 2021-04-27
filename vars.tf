variable "tags" {
  description = "(optional) a map of 'key'= 'value' pairs to add as tags. In addition to the default tags"
  type        = map(string)
  default     = null
}

variable "project_code" {
  type        = string
  description = "The Project/Cost Code assigned to the project"
  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,6}$", var.project_code))
    error_message = "The project code name should be without spaces and less than 5 characters."
  }
}

variable "environment" {
  type        = string
  description = "The staging environment where the new vNet will be deployed. For example 'Dev'"
  default     = "Dev"
  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,6}$", var.environment))
    error_message = "The environment name should be without spaces and less than 5 characters."
  }
}

variable "location" {
  description = "The azure region where the new resource will be created"
  type        = string
  default     = "UK South"
}

variable "vm_name" {
  description = "The name to assign to the VM."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,14}$", var.vm_name))
    error_message = "The name should be without spaces and less than 14 characters."
  }
}

variable "resource_group_name" {
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
  sensitive   = true
}

variable "admin_username" {
  description = "The username to assign tot he new VMs admin user account"
  default     = "adminuser"
  type        = string
  sensitive   = true
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
