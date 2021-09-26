terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}


provider "azurerm" {
    features {}
    subscription_id = var.ARM_SUBSCRIPTION_ID
    client_id       = var.ARM_CLIENT_ID
    client_secret   = var.SECRET_VALUE
    tenant_id       = var.ARM_TENANT_ID
}


resource "azurerm_resource_group" "example_resourcegroup" {
    name = "${var.GLOBAL_RESOURCENAME_PREFIX}rg"
    location = var.GLOBAL_LOCATION
}

