terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    region = var.region
}

data "aws_ecs_cluster" "main" {
    cluster_name = var.cluster_name
}

data "aws_iam_user" "kms-operator" {
    provider = aws
    user_name = "kms-operator"
}

data "aws_vpc" "main" {
    id = var.vpc_id
}

data "aws_iam_role" "ecs_task_execution_role" {
    name = "ecsTaskExecutionRole"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
    name = "/ecs/${var.container_name}"
    retention_in_days = 7
}


resource "aws_security_group" "main" {
    vpc_id = data.aws_vpc.main.id
    ingress {
        from_port = var.container_port  # Assuming KMS API uses HTTPS
        to_port = var.container_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "0"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.container_name
    }
}

resource "aws_ecs_task_definition" "main" {
    container_definitions = jsonencode([
        {
            name = var.container_name
            image = var.image
            essential = true
            environment = var.environment_variables
            portMappings = [
                {
                    containerPort = var.container_port
                    hostPort = var.host_port
                }
            ]
            repositoryCredentials = {
                credentialsParameter = "arn:aws:secretsmanager:eu-north-1:767397984189:secret:test/pull_secret-wL1ehS"
            }
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    "awslogs-group"         = "/ecs/${var.container_name}"
                    "awslogs-region"        = var.region
                    "awslogs-stream-prefix" = var.container_name
                }
            }
        }
    ])
    family                = var.family
    network_mode          = var.network_mode
    requires_compatibilities = []
    cpu = var.cpu
    memory = var.memory
    execution_role_arn    = var.is_ghcr_image ? data.aws_iam_role.ecs_task_execution_role.arn : null
    depends_on = [aws_cloudwatch_log_group.ecs_log_group]
}

resource "aws_ecs_service" "main" {
    name = var.service_name
    cluster = data.aws_ecs_cluster.main.arn
    task_definition = aws_ecs_task_definition.main.arn
    desired_count = var.desired_count
    capacity_provider_strategy {
        capacity_provider = "FARGATE_SPOT"
        weight = 1
    }
    network_configuration {
        subnets = var.subnets
        security_groups = [aws_security_group.main.id]
        assign_public_ip = var.assign_public_ip
    }

    depends_on = [aws_ecs_task_definition.main]
}