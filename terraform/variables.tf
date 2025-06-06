variable "prefix" {
  description = "Prefix for all resources"
  default     = "webserver"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "webserver-rg"
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  default     = "webserver-vm"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}