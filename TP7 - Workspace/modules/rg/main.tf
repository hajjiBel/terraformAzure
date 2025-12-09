
resource "azurerm_resource_group" "tftraining-rg" {
  name     = var.name
  location = var.location
}
