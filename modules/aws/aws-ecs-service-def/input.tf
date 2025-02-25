variable "region" {
    type = string
    description = "AWS region"
}
variable "desired_count" {
    type = number
    description = "Number of instances"
}
# generate the rest of the variables here based on main.tf
variable "container_name" {
    type = string
    description = "Name of the container"
}

variable "cluster_name" {
    type = string
    description = "Name of the ECS cluster"
}

variable "image" {
    type = string
    description = "Image of the container"
}

variable "container_port" {
    type = number
    description = "Port of the container"
}

variable "host_port" {
    type = number
    description = "Port of the host"
}

variable "family" {
    type = string
    description = "Family of the task definition"
}

variable "network_mode" {
    type = string
    description = "Network mode of the task definition"
}

variable "cpu" {
    type = string
    description = "CPU of the task definition"
}

variable "memory" {
    type = string
    description = "Memory of the task definition"
}

variable "service_name" {
    type = string
    description = "Name of the service"
}

variable "subnets" {
    type = list(string)
    description = "Subnets of the network configuration"
}

variable "assign_public_ip" {
    type = bool
    description = "Assign public IP to the task"
}

variable "is_ghcr_image" {
    description = "Whether to use the GitHub Container Registry"
    type        = bool
    default = false
}

variable "vpc_id" {
    type = string
    description = "VPC Name"
}

variable "environment_variables" {
    type = list(object({
        name  = string
        value = string
    }))
    description = "Environment variables"
}