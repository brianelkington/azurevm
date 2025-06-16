provider "azurerm" {
  subscription_id = "ab98a90e-7153-476e-b323-ae4a15843e5f"

  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}