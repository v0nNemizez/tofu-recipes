/*
  This Terraform configuration file sets up a network infrastructure in Azure.
  It creates a resource group, a virtual network, and two subnets.
  It also creates a route table with a route for the testcluster subnet.
  
  File: /Users/simen/Documents/git/private/tofu-recipes/modules/network/main.tf
  
  Terraform Version: 0.15.0
  
  Required Providers:
    - azurerm (version 3.90.0)
  
  Resources:
    - azurerm_resource_group.sc-saas-rg: A resource group in Azure.
    - azurerm_virtual_network.service-vnet: A virtual network in Azure.
    - azurerm_subnet.management_subnet: A subnet for management purposes.
    - azurerm_subnet.testcluster_subnet: A subnet for the testcluster.
    - azurerm_route_table.example: A route table with a route for the testcluster subnet.
*/
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "sc-saas-rg" {
  location = var.location
  name     = "${var.name}-rg"
}


resource "azurerm_virtual_network" "service-vnet" {
  address_space       = ["10.0.0.0/20"]
  location            = azurerm_resource_group.sc-saas-rg.location
  name                = "${var.name}-vnet"
  resource_group_name = azurerm_resource_group.sc-saas-rg.name
}

resource "azurerm_subnet" "management_subnet" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "management-subnet"
  resource_group_name  = azurerm_resource_group.sc-saas-rg.name
  virtual_network_name = azurerm_virtual_network.service-vnet.name
}



resource "azurerm_route_table" "example" {
  name                          = "subnet-route-table"
  location                      = azurerm_resource_group.sc-saas-rg.location
  resource_group_name           = azurerm_resource_group.sc-saas-rg.name
  disable_bgp_route_propagation = true

  route {
    name           = "testcluster_subnet"
    address_prefix = "10.0.2.0/24"
    next_hop_type  = "VnetLocal"
  }

  tags = {
    environment = "test"
  }
}

