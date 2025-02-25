terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet1_cidr_block
    availability_zone = var.availability_zone
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet2_cidr_block
    availability_zone = var.availability_zone2
}

resource "aws_subnet" "subnet3" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet3_cidr_block
    availability_zone = var.availability_zone3
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = var.igw_name
    }
}

resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = var.route_table_name
    }
}

resource "aws_route_table_association" "subnet1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.sg_name
    }
}

#resource "aws_eip" "nat" {
#    vpc = true
#}

#resource "aws_nat_gateway" "nat" {
#    allocation_id = aws_eip.nat.id
#    subnet_id     = aws_subnet.subnet1.id  # Assuming subnet1 is a public subnet
#}

#resource "aws_route_table" "private" {
#    vpc_id = aws_vpc.main.id

#    route {
#        cidr_block = "0.0.0.0/0"
#        nat_gateway_id = aws_internet_gateway.main.id
#    }

#    tags = {
#        Name = "private-route-table"
#    }
#}

resource "aws_route_table_association" "private_subnet1" {
    subnet_id      = aws_subnet.subnet2.id  # Assuming subnet2 is a private subnet
    route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "private_subnet2" {
    subnet_id      = aws_subnet.subnet3.id  # Assuming subnet3 is a private subnet
    route_table_id = aws_route_table.main.id
}

output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnet1_id" {
    value = aws_subnet.subnet1.id
}

output "subnet2_id" {
    value = aws_subnet.subnet2.id
}

output "subnet3_id" {
    value = aws_subnet.subnet3.id
}