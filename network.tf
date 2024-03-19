# TODO where do I put network security group (NSG) and route table (RT) if any ?
# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "${var.namespace}-example-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = [var.vnet_cidr]

  lifecycle {
    create_before_destroy = true
  }
}

# Private Subnet in VPN
resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
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

  lifecycle {
    create_before_destroy = true
  }
  # private_link_service_network_policies_enabled = true #?
}


####
# 5. Create a Private Endpoint for the Function App and connect it to the Subnet
#    in the Vnet you created by using Terraform only. 
# experience error:
/*
   Error: creating Private Endpoint (Subscription: "f677936f-e340-450a-9752-fc45f2470087"
│ Resource Group Name: "clalit-rg"
│ Private Endpoint Name: "clalit-private-endpoint"): performing CreateOrUpdate: unexpected status 400 with error: 
  MissingParameterOnPrivateLinkServiceConnection: Private link service connection 
  /subscriptions/f677936f-e340-450a-9752-fc45f2470087/resourceGroups/clalit-rg/providers/Microsoft.Network/privateEndpoints/clalit-private-endpoint/privateLinkServiceConnections/clalit-function-app-connection
  is missing required parameter 'group Id'.


Error: creating Private Link Service: (Name "clalit-pls" / Resource Group "clalit-rg"):
 network.PrivateLinkServicesClient#CreateOrUpdate: Failure sending request:
  StatusCode=400 -- Original Error: Code="PrivateLinkServiceCannotBeCreatedInSubnetThatHasNetworkPoliciesEnabled" 
  Message="Private link service /subscriptions/f677936f-e340-450a-9752-fc45f2470087/resourceGroups/clalit-rg/providers/Microsoft.Network/privateLinkServices/clalit-pls 
  cannot be created in a subnet /subscriptions/f677936f-e340-450a-9752-fc45f2470087/resourceGroups/clalit-rg/providers/Microsoft.Network/virtualNetworks/clalit-example-vnet/subnets/private-subnet 
  since it has private link service network policies enabled." Details=[]
│
│   with azurerm_private_link_service.example,
│   on network.tf line 88, in resource "azurerm_private_link_


# Create a Private Endpoint for the Function App
resource "azurerm_private_endpoint" "example_function_app" {
  name                = "${var.namespace}-private-endpoint"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  subnet_id           = azurerm_subnet.private_subnet.id

  private_service_connection {
    name                           = "${var.namespace}-function-app-connection"
    private_connection_resource_id = azurerm_linux_function_app.example.id
    is_manual_connection           = false 
    #     subresource_names              = ["sites"] #?
  }
}

data "azurerm_subscription" "current" {}

# grabbed as is here https://github.com/hashicorp/terraform-provider-azurerm/blob/main/examples/private-endpoint/private-link-service/main.tf
resource "azurerm_public_ip" "example" {
  name                = "${var.namespace}-pip"
  sku                 = "Standard"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "example" {
  name                = "${var.namespace}-lb"
  sku                 = "Standard"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.example.name
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_private_link_service" "example" {
  name                = "${var.namespace}-pls"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  auto_approval_subscription_ids = [data.azurerm_subscription.current.subscription_id]
  visibility_subscription_ids    = [data.azurerm_subscription.current.subscription_id]

  nat_ip_configuration {
    name      = azurerm_public_ip.example.name
    subnet_id = azurerm_subnet.private_subnet.id
    primary   = true
  }

  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.example.frontend_ip_configuration.0.id]
}


# Get the ID of the Function App
data "azurerm_linux_function_app" "example" {
  name                = azurerm_linux_function_app.example.name
  resource_group_name = azurerm_resource_group.example.name
}

*/ # commented due to error

/* # commented due to error 
# 6. Create a Private Endpoint for the Storage Account and connect it to the Subnet in the Vnet you created

# Create a Private Endpoint for the Storage Account
resource "azurerm_private_endpoint" "example_storage_account" {
  name                = "example-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  subnet_id           = azurerm_subnet.private_subnet.id

  private_service_connection {
    name                           = "storage-account-connection"
    private_connection_resource_id = azurerm_storage_account.example.id
    is_manual_connection           = false
  }
}

*/ # commented due to error
