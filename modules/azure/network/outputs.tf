output vnet_name {
  value       = azurerm_virtual_network.service-vnet.name
  sensitive   = false
  description = "description"
  depends_on  = []
}

output location {
  value       = azurerm_resource_group.sc-saas-rg.location
  sensitive   = false
  description = "description"
  depends_on  = []
}

output resource_group_id {
  value       = azurerm_resource_group.sc-saas-rg.id
  sensitive   = false
  description = "description"
  depends_on  = []
}

output resource_group_name {
  value       = azurerm_resource_group.sc-saas-rg.name
  sensitive   = false
  description = "description"
  depends_on  = []
}

output virtual_network_name {
  value       = azurerm_virtual_network.service-vnet.name
  sensitive   = false
  description = "description"
  depends_on  = []
}
output subnet_management_id {
  value       = azurerm_subnet.management_subnet.id
  sensitive   = false
  description = "description"
  depends_on  = []
}

