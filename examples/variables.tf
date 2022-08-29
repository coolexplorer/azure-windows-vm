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

# Network
variable "network_rg_name" {
  type        = string
  description = "The resource group name for network resources"
}

variable "virtual_network_name" {
  type        = string
  description = "The virtual network name"
}

variable "subnet_name" {
  type        = string
  description = "The subnet name"
}

# Compute
variable "compute_rg_name" {
  type        = string
  description = "The resource group name for the compute resources"
}

variable "vm_size" {
  type        = string
  description = "The vm size"
  default     = "Standard_A2_v2"
}

variable "image_offer" {
  type        = string
  description = "MS marketplace image offer"
}

variable "image_publisher" {
  type        = string
  description = "MS marketplace image publisher"
}

variable "image_sku" {
  type        = string
  description = "MS marketplace image sku"
}

variable "image_version" {
  type        = string
  description = "MS marketplace image version"
}

# Storage
variable "os_disk_storage_account_type" {
  type        = string
  description = "The storage account type for the os disk"
  default     = "Standard_LRS"
}

# Credential
variable "admin_username" {
  sensitive = true
}

variable "admin_password" {
  sensitive = true
}

variable "azure_client_id" {
  sensitive = true
}

variable "azure_tenant_id" {
  sensitive = true
}

variable "azure_subscription_id" {
  sensitive = true
}

variable "azure_client_secret" {
  sensitive = true
}

variable "azure_client_secret_id" {
  sensitive = true
}

