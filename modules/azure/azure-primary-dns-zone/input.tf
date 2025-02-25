variable "domain" {
  type = string
  description = "DNS name"
}

variable "resource_group" {
  type = string
  default = "skogum-dns-zones"
  description = "Resource Group"
}