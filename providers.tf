provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}