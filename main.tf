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

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Creating VNET

resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-Terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.100.0/24"]

  subnet {
    name           = "vnet-subnet1"
    address_prefix = "192.168.100.64/26"
  }

  subnet {
    name           = "vnet-subnet2"
    address_prefix = "192.168.100.128/26"
  }

  subnet {
    name           = "vnet-subnet3"
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
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}

# Requesting Public IP

resource "azurerm_public_ip" "publicIP" {
  name                = "test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Dynamic"
}

# Creating Virtual Network Gateway

resource "azurerm_virtual_network_gateway" "vng" {
  name                = "test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "ExpressRoute"
  sku      = "Standard"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.publicIP.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.gateway_subnet.id
  }

}

# Creating a Connection to AVS using a provided Authorization Key - add to variables.tf

data "azurerm_vmware_private_cloud" "avs_sddc" {
  name                = var.azurerm_vmware_private_cloud_name
  resource_group_name = var.resource_group_name_AVS
}

output "sddc_express_route" {
  value = data.azurerm_vmware_private_cloud.avs_sddc.circuit[0].express_route_id
}

resource "azurerm_virtual_network_gateway_connection" "connection" {
  name                = "VNET_to_AVS"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type                            = "ExpressRoute"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vng.id

  authorization_key = var.authorization_key
  express_route_circuit_id = data.azurerm_vmware_private_cloud.avs_sddc.circuit[0].express_route_id
#  express_route_circuit_id = var.avs_express_route_id
}

data "azurerm_virtual_network_gateway_connection" "example55" {
  name                = "VNET_to_AVS"
  resource_group_name = azurerm_resource_group.rg.name
}

output "sddc_express_route2" {
  value = example55.express_route_circuit_id
}