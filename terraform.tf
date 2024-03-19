# Configure Terraform to use Azure Blob Storage for state storage
#   storage_account_name fetched manually from terraform state list of ../create_az_state
#  have to set ACCOUNT_KEY=$(az storage account keys list --resource-group "tfstate" --account-name tfstorageaccount3bfa6 --query '[0].value' -o tsv)
#  export ARM_ACCESS_KEY=$ACCOUNT_KEY

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
 
    storage_account_name = "tfstorageaccountc9or8"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }
}
