data "azurerm_platform_image" "training-image" {
location = "France Central"
  publisher = "Canonical"
  offer     = "ubuntu-24_04-lts"
  sku       = "server"
  version  = "latest"
}  
  

