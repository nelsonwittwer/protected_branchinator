resource "aws_cloudwatch_log_group" "protected_branchinator" {
  name = "protected_branchinator"

  retention_in_days = 1

  tags = {
    Environment = "prod"
    Application = "protected_branchinator"
  }
}
