resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name        = "ecs-tasks"
  path        = "/"
  description = "Role for ECS tasks to access ECR and other needed resources"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "ecs_policy" {
  name        = "read_protected_branchinator"
  path        = "/"
  description = "Permissions needed for ECS tasks"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "ecr:DescribeImages",
      "Resource": "${aws_ecr_repository.protected_branchinator.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecr_attach" {
  name       = "attach ECR to ECS role"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.ecs_policy.arn
}
