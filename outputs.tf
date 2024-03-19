# Outputs

# Raw list all resources 
output "raw_list_resources" {
    description = " Print out content of resource objects as array"
    value = [azurerm_resource_group.example.name, azurerm_storage_account.example.name,azurerm_virtual_network.example.name, azurerm_subnet.private_subnet.name, 
           azurerm_linux_function_app.example.name ] #,azurerm_private_endpoint.example_function_app.name]

}


output "application__url" {
    value = "https://${azurerm_linux_function_app.example.default_hostname}/sample"
}

output "resource_group_name" {
  description = "The name of the created resource group."
  value       = try(azurerm_resource_group.example.name, null)
}

output "azurerm_storage_account" {
  description = "azurerm_storage_account  name"
  value = try(azurerm_storage_account.example.name,"something wrong")
#  sensitive = true
}

# Output the names of resources in resource group: name, id, etc
output "resource_names" {
  value = [for resource in azurerm_resource_group.example : resource]
}

output "virtual_network_name" {
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.example.name
}

output "private_subnet_name" {
  description = "The name of the created private subnet "
  value       = azurerm_subnet.private_subnet.name
}


# Use shell data source to fetch local data via script
# excercise for fun, actually
data "shell_script" "user" {
    lifecycle_commands {
        read = <<-EOF
          echo -e {\"terraform_state\": \"$(terraform.exe state list | sed -z 's/\n/ :\n  /g')\"}
        EOF 
    }
}
# "value" can be accessed like a normal Terraform map
output "terraform_state_list" {
    value = try(data.shell_script.user.output["terraform_state"], "value not exists")
}
