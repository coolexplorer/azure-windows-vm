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

resource "null_resource" "change_drive_letter" {
  triggers = {
    vm_id   = azurerm_windows_virtual_machine.instance.id
    vm_name = azurerm_windows_virtual_machine.instance.name
  }

  provisioner "file" {
    connection {
      host     = "${azurerm_windows_virtual_machine.instance.name}.${var.domain_name}"
      type     = "winrm"
      user     = "${var.bootstrap_windows_shortdomain}\\${var.bootstrap_windows_user}"
      password = var.bootstrap_windows_password
      use_ntlm = true
      https    = true
      insecure = true
    }

    source      = "${path.module}/provisioners/change-page-drive.ps1"
    destination = "C:/Windows/Temp/change-page-drive.ps1"
  }

  provisioner "remote-exec" {
    connection {
      host     = "${azurerm_windows_virtual_machine.instance.name}.${var.domain_name}"
      type     = "winrm"
      user     = "${var.bootstrap_windows_shortdomain}\\${var.bootstrap_windows_user}"
      password = var.bootstrap_windows_password
      use_ntlm = true
      https    = true
      insecure = true
    }

    inline = [
      "pwsh.exe -ExecutionPolicy RemoteSigned -File C:/Windows/Temp/change-page-drive.ps1"
    ]
  }

  provisioner "local-exec" {
    command = "sleep ${var.reboot_sleep}"
  }

  depends_on = [
    null_resource.wait_gpo
  ]
}

resource "azurerm_managed_disk" "empty_disk" {
  count                = length(local.empty_data_disks) > 0 && length(local.presynced_data_disks) == 0 ? length(local.empty_data_disks) : 0
  name                 = "${azurerm_windows_virtual_machine.instance.name}-data-disk${count.index}"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = var.os_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = local.empty_data_disks[count.index].size

  tags = {
    createdBy   = var.owner
    environment = "test"
    vm_name     = azurerm_windows_virtual_machine.instance.name
  }

  depends_on = [
    null_resource.clean_up
  ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "empty_disk_attachment" {
  count              = length(local.empty_data_disks) > 0 && length(local.presynced_data_disks) == 0 ? length(local.empty_data_disks) : 0
  managed_disk_id    = azurerm_managed_disk.empty_disk[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.instance.id
  lun                = count.index + 1
  caching            = "ReadWrite"

  depends_on = [
    azurerm_managed_disk.empty_disk
  ]
}

resource "null_resource" "initialize_empty_disk" {
  triggers = {
    empty_disk_id = azurerm_managed_disk.empty_disk[count.index].id
  }

  count = length(local.empty_data_disks) > 0 && length(local.presynced_data_disks) == 0 ? length(local.empty_data_disks) : 0

  provisioner "file" {
    connection {
      host     = "${azurerm_windows_virtual_machine.instance.name}.${var.domain_name}"
      type     = "winrm"
      user     = "${var.bootstrap_windows_shortdomain}\\${var.bootstrap_windows_user}"
      password = var.bootstrap_windows_password
      use_ntlm = true
      https    = true
      insecure = true
      timeout  = "30m"
    }

    source      = "${path.module}/provisioners/initialize-disk.ps1"
    destination = "C:/Windows/Temp/initialize-disk.ps1"
  }

  provisioner "remote-exec" {
    connection {
      host     = "${azurerm_windows_virtual_machine.instance.name}.${var.domain_name}"
      type     = "winrm"
      user     = "${var.bootstrap_windows_shortdomain}\\${var.bootstrap_windows_user}"
      password = var.bootstrap_windows_password
      use_ntlm = true
      https    = true
      insecure = true
    }

    inline = [
      "pwsh.exe -ExecutionPolicy RemoteSigned -File C:/Windows/Temp/initialize-disk.ps1",
      "pwsh.exe -c Remove-Item C:/Windows/Temp/initialize-disk.ps1 -Force"
    ]
  }

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.empty_disk_attachment
  ]
}
