terraform {
  backend "azurerm" {    
    resource_group_name  = "my-training-rg3"
    storage_account_name = "storageaccounthajji3"
    container_name       = "training-container"
    key                  = "terraform.tfstate"
    
  }
}