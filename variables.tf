variable "location" {
  type        = string
  description = "Azure Region name"
  default     = "Canada Central"
}

variable "name_prefix" {
  type        = string
  description = "The virtual machine name's prefix"
  default     = "test-vm"
}

variable "owner" {
  type        = string
  description = "The owner name"
  default     = "Allen"
}

# Compute
variable "compute_rg" {
  type        = any
  description = "The resource group object for the compute resources"
}

variable "vm_size" {
  type        = string
  description = "The vm size"
  default     = "Standard_A2_v2"
}

variable "winrm_initialization" {
  type        = bool
  description = "The boolean whether winrm initialization will do or not"
  default     = true
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "The storage account type for the os disk"
  default     = "Standard_LRS"
}

variable "image_offer" {
  type        = string
  description = "MS marketplace image offer"
  default     = "WindowsServer"
}

variable "image_publisher" {
  type        = string
  description = "MS marketplace image publisher"
  default     = "MicrosoftWindowsServer"
}

variable "image_sku" {
  type        = string
  description = "MS marketplace image sku"
  default     = "2019-Datacenter"
}

variable "image_version" {
  type        = string
  description = "MS marketplace image version"
  default     = "latest"
}

# Storage
variable "disks" {
  type = list(object({
    size = number
  }))
  default = []
}

# Network
variable "network_rg" {
  type        = any
  description = "The resource group object for network resources"
}

variable "virtual_network" {
  type        = any
  description = "The virtual network object"
}

variable "subnet" {
  type        = any
  description = "The subnet object"
}

# Credential
variable "admin_username" {
  sensitive = true
}

variable "admin_password" {
  sensitive = true
}
