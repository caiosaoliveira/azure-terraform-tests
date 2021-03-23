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

# subnet {
#     name           = "subnet4"
#     address_prefix = "192.168.100.0/26"
#   }

  tags = {
    environment = "Tests Terraform"
  }
}

# resource "azurerm_subnet" "examplesubnet" {
#   name                 = "Subnet-Terraform-01"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["192.168.100.0/26"]
# }

# resource "azurerm_subnet" "examplesubnet2" {
#   name                 = "Subnet-Terraform-02"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["192.168.100.64/26"]
# }

# resource "azurerm_subnet" "examplesubnet3" {
#   name                 = "Subnet-Terraform-03"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["192.168.100.128/26"]
# }

resource "azurerm_subnet" "example" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["192.168.100.0/26"]
}

resource "azurerm_public_ip" "example" {
  name                = "test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  allocation_method = "Dynamic"
}

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
    subnet_id                     = azurerm_subnet.example.id
  }

}