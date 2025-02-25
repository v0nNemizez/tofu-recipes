variable "domain" {
  type = string
  description = "DNS name (TLD)"
}

variable "subdomain" {
  type = string
  description = "subdomain"
}

variable "resource_group" {
  type = string
  default = "skogum-dns-zones"
  description = "Resource Group"
}