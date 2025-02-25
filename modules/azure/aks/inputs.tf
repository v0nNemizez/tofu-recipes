variable "resource_group" {
  description = "Name of resource group"
  type = string
  default = "simenstestgruppe"
}

variable "region" {
  description = "Region"
  type = string
  default = "norwayeast"
}

variable "cluster_name" {
  description = "name of AKS cluster"
  type = string
  default = "simenstestcluster"
}

variable "dns_prefix" {
  type = string
}

variable "default_node_count" {
  description = "Count of nodes in the default node pool"
  type = number
  default = 1
}

variable "default_node_type" {
  description = "Type of node"
  type = string
  default = "Standard_D2_v2"
}
variable "github_token" {
  type=string
}

variable "cluster_url" {
  type = string
  description = "internal url for cluster"
}

variable "cluster_subnet_id" {
  type = string
  description = "subnet id for cluster"
}