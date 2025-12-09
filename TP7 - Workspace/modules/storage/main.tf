resource "azurerm_storage_account" "sa" {
  name                     = var.account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = module.rg.name
  location            = module.rg.location     # ← this is now the correct variable

  account_name   = "storageaccounthajji3"
  container_name = "training-container"
}