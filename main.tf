# Getting Authorization Key on AVS for Connection setup on Virtual Network Gateway

resource "azurerm_express_route_circuit_authorization" "example" {
  name                       = "exampleERCAuth"
  express_route_circuit_name = "tnt26-cust-p03-eastus-er"
  resource_group_name        = "tnt26-cust-p03-eastus"
}

