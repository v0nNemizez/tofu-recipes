# Add aws as required provider
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

data "aws_iam_role" "ecs_task_execution_role" {
    name = "ecsTaskExecutionRole"
}

data "aws_vpc" "main" {
    id = var.vpc_id
}

resource "aws_iam_policy" "secretsmanager_access" {
    name        = "secretsmanager_access"
    description = "Policy to allow access to Secrets Manager"
    policy      = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = [
                    "secretsmanager:GetSecretValue"
                ],
                Effect   = "Allow",
                Resource = "arn:aws:secretsmanager:eu-north-1:767397984189:secret:test/pull_secret-wL1ehS"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_secretsmanager_access" {
    role       = data.aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.secretsmanager_access.arn
}



#Create a ECS cluster with the name defined in the input variables. The cluster should be created in the subnet created in the previous step.
#Capacity provider strategy should be defined with the FARGATE_SPOT capacity provider

resource "aws_ecs_cluster" "main" {
    name = var.cluster_name
}

#Create a cluster capacity provider strategy with the FARGATE_SPOT capacity provider
resource "aws_ecs_cluster_capacity_providers" "fargate_spot" {
    cluster_name = aws_ecs_cluster.main.name
    capacity_providers = ["FARGATE_SPOT"]

    default_capacity_provider_strategy {
        capacity_provider = "FARGATE_SPOT"
        base = 1
        weight = 100
    }

}