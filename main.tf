resource "random_string" "name_postfix" {
  length  = 4
  numeric = true
  special = false
}

resource "azurerm_windows_virtual_machine" "instance" {
  name                  = "${var.name_prefix}-${random_string.name_postfix.result}"
  location              = var.location
  resource_group_name   = var.compute_rg.name
  network_interface_ids = [azurerm_network_interface.instance_ni.id]
  size                  = var.vm_size

  computer_name  = "${var.name_prefix}-${random_string.name_postfix.result}"
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data = base64encode(templatefile("${path.module}/provisioners/initialize-config.ps1", {
    winrm_initialization = var.winrm_initialization
  }))

  patch_mode               = "Manual"
  enable_automatic_updates = false
  provision_vm_agent       = true
  timezone                 = "Pacific Standard Time"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.name_prefix}-${random_string.name_postfix.result}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.disks[0].size
  }

  additional_unattend_content {
    setting = "AutoLogon"
    content = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
  }

  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = file("${path.module}/provisioners/FirstLogonCommands.xml")
  }

  tags = {
    createdBy   = var.owner
    environment = "test"
  }

  winrm_listener {
    protocol = "Http"
  }
}
