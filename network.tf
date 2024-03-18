# TODO where do I put network security group (NSG) and route table (RT) if any ?
# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "${var.namespace}-example-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = [var.vnet_cidr]
}

# Subnet 1
resource "azurerm_subnet" "terraform_subnet_1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "example-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms" # ? Microsoft.Web/sites
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  
  # enforce_private_link_service_network_policies = true #?
}


####
# 5. Create a Private Endpoint for the Function App and connect it to the Subnet
#    in the Vnet you created by using Terraform only. 


# Create a Private Endpoint for the Function App
resource "azurerm_private_endpoint" "example-_func_app" {
  name                = "${var.namespace}-private-endpoint"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  subnet_id           = azurerm_subnet.terraform_subnet_1.id

  private_service_connection {
    name                           = "${var.namespace}-function-app-connection"
    private_connection_resource_id = azurerm_linux_function_app.example.id
    is_manual_connection           = false 
    #     subresource_names              = ["sites"] #?
  }
}

# is this Private link???
resource "azurerm_app_service_virtual_network_swift_connection" "fn_vnet_swift" {
  app_service_id = azurerm_linux_function_app.example.id
  subnet_id      = azurerm_subnet.terraform_subnet_1.id
}


# Get the ID of the Function App
data "azurerm_linux_function_app" "example" {
  name                = azurerm_linux_function_app.example.name
  resource_group_name = azurerm_resource_group.example.name
}



/*
# 6. Create a Private Endpoint for the Storage Account and connect it to the Subnet in the Vnet you created

# Create a Private Endpoint for the Storage Account
resource "azurerm_private_endpoint" "example_storage_account" {
  name                = "example-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "storage-account-connection"
    private_connection_resource_id = azurerm_storage_account.example.id
    is_manual_connection           = false
  }
}

# Get the ID of the Storage Account
data "azurerm_storage_account" "example" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

# Get the ID of the Subnet
data "azurerm_subnet" "example" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}
*/
