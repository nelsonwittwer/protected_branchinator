resource "aws_ecs_cluster" "protected_branchinator" {
  name = "protected_branchinator"
}

resource "aws_ecs_task_definition" "protected_branchinator" {
  family                   = "protected_branchinator"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "memory": ${var.fargate_memory},
    "image": "${var.container_image}",
    "name": "protected_branchinator",
    "networkMode": "awsvpc"
  }
]
DEFINITION
}

resource "aws_ecs_service" "protected_branchinator" {
  name               = "protected_branchinator"
  cluster            = "${aws_ecs_cluster.protected_branchinator.id}"
  task_definition    = "${aws_ecs_task_definition.protected_branchinator.arn}"
  desired_count      = "${var.container_count}"
  launch_type        = "FARGATE"

  network_configuration {
    subnets          = ["${aws_subnet.public.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.http_access.id}"]
  }
}
