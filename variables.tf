# Multi-Cloud Lab Terraform Variables

## Azure Connection Details Variables

variable "arm_client_id" {
    description = "Application (Client ID)"
}

variable "arm_client_secret" {
    description = "Client Secret Value"
}

variable "arm_subscription_id" {
    description = "Azure Subscription ID"
}

variable "arm_tenant_id" {
    description = "Directory tenant ID"
}

## Azure VMware Solution Variables

variable "resource_group_name" {
    description = "Azure Resource Group Name"
}

variable "resource_group_location" {
    description = "Azure Resource Group Location"
}

variable "authorization_key" {
    description = "AVS ExpressRoute Authorization Key - Need to request manually on AVS portal"
}

variable "azurerm_vmware_private_cloud_name" {
    description = "Name of the AVS SDDC"
}

variable "resource_group_name_AVS" {
    description = "Azure Resource Group Name for AVS"
}

#variable "azurerm_vmware_private_cloud_sku" {
#    description = "The host type used for AVS"
#}

#variable "azurerm_vmware_private_cloud_management_cidr" {
#    description = "This is the management network CIDR range"
#}

#variable "azurerm_vmware_private_cloud_host_count" {
#    description = "Number of hosts in the SDDC"
#}