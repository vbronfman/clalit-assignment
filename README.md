# Clalit-assignment
home assignment Azure

## Description
1. Install Terraform on your stand 
2. Execute init and learn the Terraform workflow 
3. Connect your code to the Azure environment and save the state in Azure - +
4. Set up the following components using Terraform azurerm (resource manager?)
- Resourcegroup
 - VNET 
 - DiagnosticsService (?)
 - Storage account 
 - Function App 

5. Create a Private Endpoint for the Function App and connect it to the Subnet in the Vnet you created by using Terraform only.  
6. Create a Private Endpoint for the Storage Account and connect it to the Subnet in the Vnet you created 
7. Define access between the Function app and the Storage account by using Managed Identity 
8. Export the names of the Resources you created by using Output

## Task provisioning 

Working env-t Windows 10, Git Bash 

Azure subscription Basic "Azure Plan"

### 3. Connect your code to the Azure environment and save the state in Azure

1. Installed  AZURE CLI (see references)
2. Create creds to connect. Run _az login_ without any parameters and follow the instructions to sign in to Azure.
   
 _$ az login_

> [!NOTE]  For best of my understanding, Terraform only supports authenticating to Azure via the Azure CLI 

3. Use a specific Azure subscription
 
_$ az account list --query "[?user.name=='vlad.bronfman@gmail.com'].{Name:name, ID:id, Default:isDefault}" --output Table_

Name              	ID                                	Default
--------------------  ------------------------------------  ---------
Azure subscription 1  xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx  True

4. If you're creating a service principal from Git Bash, set the __MSYS_NO_PATHCONV__ environment variable.

_export MSYS_NO_PATHCONV=1_
 
5. To create a service principal,  run az ad sp create-for-rbac.
   
$ _az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>_

Creating 'Contributor' role assignment under scope '/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx'

The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{

  "appId": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx",  
  
  "displayName": "service_principal_tmp",
  
  "password": "XXXXXXXXXX",
  
  "tenant": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"
  
}

> [!TIP]
> For this article, a service principal with a Contributor role is being used. For more information about Role-Based Access Control (RBAC) roles, (see RBAC: Built-in roles)[https://learn.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles].

6. Update .bashrc to  specify credentials to Terraform via environment variables.

_~/.bashrc:_

_export ARM_SUBSCRIPTION_ID="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"_

_export ARM_TENANT_ID="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"_

_export ARM_CLIENT_ID="service_principal_tmp"_

_export ARM_CLIENT_SECRET="XXXXXXXXXXXXXXXXXXXXX"_

Run _source ~/.bashrc_

7. Terraform source in ./create_az_state creates an Azure Storage Account for storing Terraform state
   
_cd ./create_az_state_

_terraform init_

_terraform apply -auto-aprove_


8. Create storage for state
   
https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform#2-configure-remote-state-storage-account  

To configure the backend state, you need the following Azure storage information:

__storage_account_name__: The name of the Azure Storage account.

__container_name__: The name of the blob container.

__key__: The name of the state store file to be created.

__access_key__: The storage access key.

_$ ACCOUNT_KEY=$(az storage account keys list --resource-group "tfstate" --account-name tfstorageaccount3bfa6 --query '[0].value' -o tsv)_

_export ARM_ACCESS_KEY=$ACCOUNT_KEY_

9. Update terraform.tf with number of actual number

terraform {
   
  backend "azurerm" {
  
    resource_group_name  = "tfstate"
 
    storage_account_name = "tfstorageaccountc9or8"
    
    container_name       = "terraformstate"
    
    key                  = "terraform.tfstate"
    
  }
  
}
    

### 4. Set up the following components using Terraform azurerm 
- Resourcegroup
- VNET 
- DiagnosticsService (?)
- Storage account 
- Function App

> [!IMPORTANT]  
> For time saving sake, used code example from Using [FastAPI Framework with Azure Functions](https://github.com/Azure-Samples/fastapi-on-azure-functions#using-fastapi-framework-with-azure-functions) .
>  You can add any existing Azure function to the current Terraform project as a submodule:
> 
>  _git submodule add https://github.com/Azure-Samples/fastapi-on-azure-functions.git_
>
> #### Add Your Azure Function Code (Optional)
>
> _git submodule add {Your function git repository}_
>
>  #### Update submodule (Optional)
>
> If you will use the example code, update the submodule code before proceeding.
>
> _git submodule update --init --recursive_
>

## Deploy

terraform init

terraform apply -auto-approve


## Clean up

Destroy the deployment:

_terraform apply -destroy -auto-approve_


## References
https://github.com/vbronfman/manning-code Terraform in action  PART 2 TERRAFORM IN THE WILD ................. 103

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli#install-or-update 

https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash

https://www.linkedin.com/pulse/azure-function-python-deployment-terraform-huaifeng-qin-jfjtc/

https://learn.microsoft.com/en-us/azure/app-service/overview-vnet-integration


