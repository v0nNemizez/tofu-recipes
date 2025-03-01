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


data "azurerm_subscription" "current" {}


resource "azurerm_kubernetes_cluster" "example" {
  name                = var.cluster_name
  location            = var.region
  resource_group_name = var.resource_group
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.default_node_count
    vm_size    = var.default_node_type
    vnet_subnet_id  = var.cluster_subnet_id

  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin    = "azure"
    service_cidr      = "10.1.0.0/16"  # Update this to a non-overlapping CIDR
    dns_service_ip    = "10.1.0.10"
  }

  tags = {
    Environment = "test"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "infra_nodes" {
  name                  = "infra"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  priority              = "Spot"
  eviction_policy       = "Delete"
  node_taints           = []

  tags = {
    Environment = "test"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "example" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  priority              = "Spot"
  eviction_policy       = "Delete"
  node_taints           = []

  tags = {
    Environment = "test"
  }

  depends_on = [azurerm_kubernetes_cluster.example]
}

resource "null_resource" "get-creds" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.resource_group}  --name ${var.cluster_name} --overwrite-existing"
  }
  depends_on = [azurerm_kubernetes_cluster.example]
}
