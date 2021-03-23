# Authentication Details

provider "azurerm" {
  features {}

  subscription_id = var.arm_subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
  tenant_id       = var.arm_tenant_id

  disable_correlation_request_id = true
}

# Creating Resource Group

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Creating VNET

resource "azurerm_virtual_network" "example" {
  name                = "VNET-Terraform"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["192.168.100.0/24"]

  subnet {
    name           = "subnet1"
    address_prefix = "192.168.100.64/26"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "192.168.100.128/26"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "192.168.100.192/26"
  }

  subnet {
     name           = "GatewaySubnet"
     address_prefix = "192.168.100.0/26"
   }

  tags = {
    environment = "Tests Terraform"
  }
}

# Virtual Network Gateway Creation

# Getting id for Gateway Subnet

data "azurerm_subnet" "gateway_subnet" {
  name                 = "gateway"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}

# Requesting Public IP

resource "azurerm_public_ip" "example" {
  name                = "test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  allocation_method = "Dynamic"
}

# Creating Virtual Network Gateway

resource "azurerm_virtual_network_gateway" "example" {
  name                = "test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  type     = "ExpressRoute"
  sku      = "Standard"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.gateway_subnet.id
  }

}

# Getting Authorization Key on AVS for Connection setup on Virtual Network Gateway

# resource "azurerm_express_route_circuit_authorization" "example" {
#   name                       = "exampleERCAuth"
#   express_route_circuit_name = "tnt26-cust-p03-eastus-er"
#   resource_group_name        = "tnt26-cust-p03-eastus"
# }

# Creating Connection to AVS

# resource "azurerm_virtual_network_gateway_connection" "connection" {
#   name                = "vNET_to_AVS"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   type                            = "ExpressRoute"
#   virtual_network_gateway_id      = azurerm_virtual_network_gateway.example.id

#   authorization_key = 
#   express_route_circuit_id =
  
# }