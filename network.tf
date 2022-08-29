resource "azurerm_network_security_group" "allow_winrm" {
  name                = "${var.name_prefix}-${random_string.name_postfix.result}-allow-winrm"
  location            = var.location
  resource_group_name = var.network_rg != null ? var.network_rg.name : null

  security_rule {
    name                       = "winrm-http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "winrm-https"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    createdBy   = var.owner
    environment = "test"
  }
}

resource "azurerm_network_interface" "instance_ni" {
  name                = "${var.name_prefix}-${random_string.name_postfix.result}-instance-ni"
  location            = var.location
  resource_group_name = var.network_rg != null ? var.network_rg.name : null

  ip_configuration {
    name                          = "instance"
    subnet_id                     = var.subnet != null ? var.subnet.id : null
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    createdBy   = var.owner
    environment = "test"
  }

  depends_on = [
    azurerm_network_security_group.allow_winrm
  ]

}

resource "azurerm_network_interface_security_group_association" "instance_nisga_winrm" {
  network_interface_id      = azurerm_network_interface.instance_ni.id
  network_security_group_id = azurerm_network_security_group.allow_winrm.id

  depends_on = [
    azurerm_network_security_group.allow_winrm,
    azurerm_network_interface.instance_ni
  ]
}
