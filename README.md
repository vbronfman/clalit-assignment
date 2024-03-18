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

## Task processing
Working env-t Windows 10, Git Bash 
Azure subscription Basic "Azure Plan"

### 3. Connect your code to the Azure environment and save the state in Azure

1. Installed  AZURE CLI 
2. Create creds to connect. Run _az login_ without any parameters and follow the instructions to sign in to Azure.
_$ az login _

> [!NOTE]  For best of my understanding, Terraform only supports authenticating to Azure via the Azure CLI 

3. Use a specific Azure subscription
_$ az account list --query "[?user.name=='vlad.bronfman@gmail.com'].{Name:name, ID:id, Default:isDefault}" --output Table_
Name              	ID                                	Default
--------------------  ------------------------------------  ---------
Azure subscription 1  xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx  True

4. If you're creating a service principal from Git Bash, set the MSYS_NO_PATHCONV environment variable.

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
> For this article, a service principal with a Contributor role is being used. For more information about Role-Based Access Control (RBAC) roles, [see RBAC: Built-in roles]([https://learn.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles] "Built-in roles").

6. Update .bashrc to  specify credentials to Terraform via environment variables.

_~/.bashrc:
export ARM_SUBSCRIPTION_ID="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"
export ARM_TENANT_ID="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"
export ARM_CLIENT_ID="service_principal_tmp"
export ARM_CLIENT_SECRET="XXXXXXXXXXXXXXXXXXXXX"_

Run _source ~/.bashrc_

7. Terraform source in ./create_az_state creates an Azure Storage Account for storing Terraform state
_cd ./create_az_state
terraform init
terraform apply -auto-aprove_

### 4. Set up the following components using Terraform azurerm 
- Resourcegroup
- VNET 
- DiagnosticsService (?)
- Storage account 
- Function App 

## References
https://github.com/vbronfman/manning-code Terraform in action  PART 2 TERRAFORM IN THE WILD ............................. 103
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli#install-or-update 
https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash


