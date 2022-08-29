data "azurerm_resource_group" "network_rg" {
  name = var.network_rg_name
}

data "azurerm_resource_group" "compute_rg" {
  name = var.compute_rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.network_rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.network_rg.name
}

module "test_vm" {
  source = "../"

  name_prefix = var.name_prefix

  # Azure
  location = var.location

  # Azure Network
  network_rg      = data.azurerm_resource_group.network_rg
  virtual_network = data.azurerm_virtual_network.vnet
  subnet          = data.azurerm_subnet.subnet

  # Azure Compute
  compute_rg           = data.azurerm_resource_group.compute_rg
  vm_size              = var.vm_size
  winrm_initialization = true

  image_offer     = var.image_offer
  image_publisher = var.image_publisher
  image_sku       = var.image_sku
  image_version   = var.image_version

  # Storage
  os_disk_storage_account_type = var.os_disk_storage_account_type
  disks = [
    { size = 128 }
  ]

  # Credential
  admin_username = var.admin_username
  admin_password = var.admin_password
}
