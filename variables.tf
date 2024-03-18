# Define variables
variable "resource_group_name" { # have to remove from here in favor to generated name
  description = "Name of the resource group where resources will be deployed."
  type        = string
  default     = "example"
}

variable "namespace" {
    description = "Name of the project - to produce tags and names"
    type        = string
    default     = "clalit" 
}

variable "location" {
  description = "Azure region where the resources will be deployed."
  type        = string
  default     = "East US"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "function_app_name" {
    description = "Name of the Azure Function App"
    type        = string 
}

variable "azurerm_function_app_identity_id" {
  type        = string
  description = "Id for the managed identity used by the Azure Function."
}





