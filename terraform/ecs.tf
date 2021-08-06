resource "aws_ecs_cluster" "protected_branchinator" {
  name = "protected_branchinator"
}

resource "aws_ecs_task_definition" "protected_branchinator" {
  family                   = "protected_branchinator"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"

  container_definitions = <<DEFINITION
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.protected_branchinator.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "${aws_cloudwatch_log_group.protected_branchinator.name}"
      }
    },
    "cpu": ${var.fargate_cpu},
    "memory": ${var.fargate_memory},
    "image": "${aws_ecr_repository.protected_branchinator.repository_url}",
    "name": "protected_branchinator",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "protected_branchinator" {
  name               = "protected_branchinator"
  cluster            = aws_ecs_cluster.protected_branchinator.id
  task_definition    = aws_ecs_task_definition.protected_branchinator.arn
  desired_count      = var.container_count
  launch_type        = "FARGATE"

  network_configuration {
    subnets          = [data.aws_subnet.public.id]
    assign_public_ip = true
    security_groups  = [data.aws_security_group.http_access.id]
  }
}

resource "aws_ecr_repository" "protected_branchinator" {
  name = "protected_branchinator"
}
