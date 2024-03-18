
# create resource to store state
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

# Create a resource group
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location
}


# Create an Azure Storage Account for storing Terraform state
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstorageaccount${random_string.resource_code.result}" # Require a unique name for the storage account
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "clalit-assignment"
  }
}

# Create a blob container within the storage account
resource "azurerm_storage_container" "tfstate" {
  name                  = "terraformstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

output "tfstate_resource_group_id" {
  value = azurerm_resource_group.tfstate
}

