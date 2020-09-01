variable "win_image_name" {
  description = "The name of the Azure VM Image to deploy from."
  type        = string
}

variable "image_rg" {
  description = "The name of the Resource Group where the VM Image resides."
  type        = string
  default     = null
}

variable "vm_rg" {
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

variable "vm_subnet" {
  description = "The name of the Subnet where the main VM NIC will be added."
  type        = string
}

variable "vm_name" {
  description = "The name to assign to the new VM"
  type        = string
}

variable "tags" {
  description = "(optional) describe your variable"
  type        = map(string)
  default     = null
}

variable "password" {
  description = "The password to assign to the new Admin user account."
  type        = string
}

variable "admin_username" {
  description = "The username to assign tot he new VMs admin user account"
  default     = "adminuser"
  type        = string
}

variable "vm_size" {
  description = "The size of the new Vm to deploy. Options can be found HERE."
  default     = "b2ms"
  type        = string
}

