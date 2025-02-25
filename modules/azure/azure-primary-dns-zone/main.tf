terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain
  resource_group_name = var.resource_group
}

data "azurerm_dns_zone" "dns_zone" {
  name = var.domain
  depends_on = [azurerm_dns_zone.dns_zone]
}

