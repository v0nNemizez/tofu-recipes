#Create inputs for all variabels in main.tf. This shoud contain a description of the variable and the type of the variable.

variable "aws_region" {
  type = string
  description = "AWS region"
}

variable "cluster_name" {
  type = string
  description = "Name of the ECS cluster"
}
variable "vpc_id" {
    type = string
    description = "ID of the VPC"
}
