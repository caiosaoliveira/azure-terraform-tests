provider "azurerm" {
  features {}

  subscription_id = var.arm_subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
  tenant_id       = var.arm_tenant_id

  disable_correlation_request_id = true
}

# Getting Authorization Key on AVS for Connection setup on Virtual Network Gateway

resource "azurerm_express_route_circuit_authorization" "examplenew" {
  name                       = "exampleERCAuth"
  express_route_circuit_name = "tnt26-cust-p03-eastus-er"
  resource_group_name        = "tnt26-cust-p03-eastus"
}

