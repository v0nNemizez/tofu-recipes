# generate inputs based on main.tf

variable "aws_region" {
  description = "The AWS region to deploy the ECS cluster"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet1_cidr_block" {
  description = "The CIDR block for subnet 1"
  type        = string
}

variable "subnet2_cidr_block" {
  description = "The CIDR block for subnet 2"
  type        = string
}

variable "subnet3_cidr_block" {
  description = "The CIDR block for subnet 3"
  type        = string
}

variable "igw_name" {
  description = "The name of the internet gateway"
  type        = string
}

variable "route_table_name" {
  description = "The name of the route table"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for subnet 1"
  type        = string
}

variable "availability_zone2" {
  description = "The availability zone for subnet 2"
  type        = string
}

variable "availability_zone3" {
  description = "The availability zone for subnet 3"
  type        = string
}
variable "sg_name" {
  description = "The name of the security group"
  type        = string
}

