<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.20 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.20 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.instance_ni](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.instance_nisga_winrm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.allow_winrm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_windows_virtual_machine.instance](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_string.name_postfix](https://registry.terraform.io/providers/hashicorp/random/3.4.2/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | n/a | `any` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Credential | `any` | n/a | yes |
| <a name="input_compute_rg"></a> [compute\_rg](#input\_compute\_rg) | The resource group object for the compute resources | `any` | n/a | yes |
| <a name="input_disks"></a> [disks](#input\_disks) | Storage | <pre>list(object({<br>    size = number<br>  }))</pre> | `[]` | no |
| <a name="input_image_offer"></a> [image\_offer](#input\_image\_offer) | MS marketplace image offer | `string` | `"WindowsServer"` | no |
| <a name="input_image_publisher"></a> [image\_publisher](#input\_image\_publisher) | MS marketplace image publisher | `string` | `"MicrosoftWindowsServer"` | no |
| <a name="input_image_sku"></a> [image\_sku](#input\_image\_sku) | MS marketplace image sku | `string` | `"2019-Datacenter"` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | MS marketplace image version | `string` | `"latest"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure Region name | `string` | `"Canada Central"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The virtual machine name's prefix | `string` | `"test-vm"` | no |
| <a name="input_network_rg"></a> [network\_rg](#input\_network\_rg) | The resource group object for network resources | `any` | n/a | yes |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The storage account type for the os disk | `string` | `"Standard_LRS"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The owner name | `string` | `"Allen"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | The subnet object | `any` | n/a | yes |
| <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network) | The virtual network object | `any` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The vm size | `string` | `"Standard_A2_v2"` | no |
| <a name="input_winrm_initialization"></a> [winrm\_initialization](#input\_winrm\_initialization) | The boolean whether winrm initialization will do or not | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->