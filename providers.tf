terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
    shell = {
      source = "scottwinkler/shell"
      version = "1.7.7"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
       prevent_deletion_if_contains_resources = false
    }
  }

/*
  subscription_id   = "${env.ARM_SUBSCRIPTION_ID}"
  tenant_id         = "${env.ARM_TENANT_ID}"
  client_id         = "${env.ARM_CLIENT_ID}"
  client_secret     = "${env.ARM_CLIENT_SECRET}"
*/
}

provider "shell" {
    #interpreter = ["/usr/bin/bash", "-c"]
    interpreter = ["C:\\Program Files\\Git\\bin\\bash.exe", "-c"]
    enable_parallelism = false
}

