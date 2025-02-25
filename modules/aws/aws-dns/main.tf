terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.90.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_route53_zone" "main" {
  name = var.domain
}

data "aws_route53_zone" "main" {
  name = var.domain
  depends_on = [aws_route53_zone.main]
}

data "azurerm_dns_zone" "main"{
  name = "skogumconsulting.cloud"
  resource_group_name = "skogum-dns-zones"
}

resource "azurerm_dns_ns_record" "aws" {
  name                = "aws"
  records             = data.aws_route53_zone.main.name_servers
  resource_group_name = "skogum-dns-zones"
  ttl                 = 0
  zone_name           = data.azurerm_dns_zone.main.name
}













