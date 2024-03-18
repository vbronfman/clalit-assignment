# Define variables
variable "resource_group_name" {
  description = "Name of the resource group where resources will be deployed."
  type        = string
  default     = "tfstate"
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

