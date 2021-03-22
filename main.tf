provider "azurerm" {
  features {}

  subscription_id = var.arm_subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
  tenant_id       = var.arm_tenant_id

  disable_correlation_request_id = true
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "example" {
  name                = "virtualNetwork1-terraform"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["192.168.100.0/24"]

  subnet {
    name           = "subnet1"
    address_prefix = "192.168.100.0/26"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "examplesubnet" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["192.168.100.128/26"]

}

resource "azurerm_subnet" "examplesubnet2" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["192.168.100.192/26"]

}