output "nic_id"     { value = azurerm_network_interface.nic.id }
output "pip_ip"     { value = azurerm_public_ip.pip.ip_address }
output "subnet_id"  { value = azurerm_subnet.subnet.id }
output "vnet_id"    { value = azurerm_virtual_network.vnet.id }