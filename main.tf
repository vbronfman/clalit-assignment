
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}


resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

# Create a storage account - stores container with blob
resource "azurerm_storage_account" "example" {
  name                     = "examplestaccount${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # account_kind             = "Storage" # ?

  tags = {
    environment = "clalit-assignment"
  }
}

# is that instead of azurerm_monitor_diagnostic_setting?
resource "azurerm_application_insights" "application_insight" {
  name                = "${var.namespace}-appinsight"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  application_type    = "other"
  # application_type   = "web" 
}

# app source zip_deploy_file
data "archive_file" "function" {
  type        = "zip"
  output_path = "${path.module}/${var.namespace}-app.zip"
  source_dir  = "${path.module}/fastapi-on-azure-functions"
}

/* commented FOR DEBUG ONLY!!! have to uncomment!
# Create a function app
resource "azurerm_linux_function_app" "example" {
  name                      = "${var.namespace}-${var.function_app_name}"
  resource_group_name       = azurerm_resource_group.example.name
  location                  = azurerm_resource_group.example.location
  service_plan_id           = azurerm_service_plan.example.id
  storage_account_name      = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
### 
  functions_extension_version = "~4" # ?

#  # how to use it, for heaven sake?
#  identity {
#    type         = "UserAssigned"
#    identity_ids = [var.azurerm_function_app_identity_id]
#  }
  

    app_settings = {
    "ENABLE_ORYX_BUILD"              = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "FUNCTIONS_WORKER_RUNTIME"       = "python"
    "AzureWebJobsFeatureFlags"       = "EnableWorkerIndexing"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.application_insight.instrumentation_key
    }
  site_config {
    runtime_scale_monitoring_enabled = true
    vnet_route_all_enabled           = true
    application_stack {
      python_version = "3.11"
    }  
  }

#application source
    zip_deploy_file = data.archive_file.function.output_path
}
*/
# Create a diagnostic settings for the function app

/* Error "AuditEvent" not supported"
resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostic-settings"
  target_resource_id = azurerm_linux_function_app.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

    enabled_log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }
}

*/

# Create a log analytics workspace
resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-log-analytics-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "PerGB2018"
}

# Create an application service plan
resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "P1v2" 
    
}

/*
resource "azurerm_user_assigned_identity" "funcid" {
  name                = "${var.namespace}-id"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}
*/

