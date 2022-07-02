variable "location" {
  description = "The azure region where the new resource will be created"
  type        = string
  default     = "UK South"
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the new VM should be created."
  type        = string
}

variable "vm_name" {
  description = "The name to assign to the VM."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,14}$", var.vm_name))
    error_message = "The name can contain alphanumeric, `_` & `-` characters only and should be less than 14 characters (with no spaces)."
  }
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VMs main NIC will reside"
}

variable "vm_size" {
  description = "The size of the new Vm to deploy."
  default     = "Standard_B2s"
  type        = string
}

variable "boot_diagnostics_storage_account_name" {
  description = "The Storage account to use for VM Boot diagnostic logging."
  type        = string
  default     = null
}

variable "admin_password" {
  description = "The password to assign to the new Admin user account."
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "The username to assign to the new VMs admin user account"
  default     = "adminuser"
  type        = string
  sensitive   = true
}

variable "storage_os_disk_config" {
  description = <<EOF
    Optional: Map to configure OS storage disk. (Caching, size, storage account type...)
    Default settings are:
      disk_size_gb           = "127" # minimum disk size of 127GB
      caching                = "ReadWrite"
      storage_account_type   = "Standard_LRS"
      disk_encryption_set_id = null
    
    Example:
      storage_os_disk_config = {
        disk_size_gb         = "200"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
EOF
  type        = map(string)
  default     = {}
}

variable "marketplace_image" {
  type        = bool
  description = "Is the image being deployed from the Marketplace? If so, then `vm_image_plan` should also be set."
  default     = false
}
variable "vm_image" {
  description = <<EOF
  Optional: Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference
  Default image is:
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"

  Find details of a publishers `offer` using PowerShell.
    $pubName = "<publisher>"
    Get-AzVMImageOffer -Location "uksouth" -PublisherName $pubName | Select Offer

  Find details of the offers `SKU` using PowerShell.
    $pubName = "<publisher>"
    $offerName = "<offer>"
    Get-AzVMImageSku -Location "uksouth" -PublisherName $pubName -Offer $offerName | Select Skus

  List the versions that are available for the image.
     $skuName = "<SKU>"
     $pubName = "<publisher>"
     $offerName = "<offer>"
     Get-AzVMImage -Location "uksouth" -PublisherName $pubName -Offer $offerName -Sku $skuName | Select Version

    when using a marketplace image from a 3rd party, you may need to first accept their license agreement.
    https://go.microsoft.com/fwlink/?linkid=862451

  Example:
    vm_image = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter"
      version   = "latest"   # changing version forces a replacement
    }
EOF
  type        = map(string)
  default     = {}
}

variable "vm_image_plan" {
  description = <<EOF
  If using an image from the Marketplace, then the Plan information should be completed.
  Do not use this input if using a Microsoft Marketplace image (publisher = "MicrosoftWindowsServer").
  When using a marketplace image, ensure the `vm_image` input parameter details are correct for the `plan`.
  
  EXAMPLE:
    vm_image_plan = {
      name      = "cis-ws2019-l1"
      product   = "cis-windows-server-2019-v1-0-0-l1"
      publisher = "center-for-internet-security-inc"
    }

EOF
  type        = map(string)
  default     = {}
}

variable "source_image_id" {
  type        = string
  description = <<EOF
  Optional: The ID of the Image which this Virtual Machine should be created from. 
  Use when deploying a custom image. One of either `source_image_id` OR `vm_image` must be used.
EOF
  default     = null
}

variable "provision_vm_agent" {
  type        = bool
  description = "Optional: Should the Azure VM agent be provisioned on this VM? Defaults to `true`"
  default     = true
}

variable "enable_automatic_updates" {
  type        = bool
  description = "Should updates be automatically applied. Defaults to `true`."
  default     = true
}

variable "tags" {
  description = "(optional) a map of 'key'= 'value' pairs to add as tags. In addition to the default tags"
  type        = map(string)
  default     = {}
}