terraform {
 required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  }


# az ad sp create-for-rbac --name hajji_principal --role Contributor --scopes /subscriptions/..


provider "azurerm" {
  features {}

  subscription_id   = "..."
  tenant_id         = "..."
  client_id         = "..."
  client_secret     = "..."
}