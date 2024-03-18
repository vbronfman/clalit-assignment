# outputs

output "web_site_url" {
    value = "https://${azurerm_linux_function_app.example.default_hostname}"
}


output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.example.name
}

output "virtual_network_name" {
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.example.name
}

output "subnet_name_1" {
  description = "The name of the created subnet 1."
  value       = azurerm_subnet.terraform_subnet_1.name
}
