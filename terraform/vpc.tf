data "aws_vpc" "main" {
  id = var.aws_vpc_id
}

data "aws_subnet" "public" {
  id = var.aws_public_subnet_id
}

data "aws_internet_gateway" "public" {
  id = var.aws_internet_gateway_id
}

data "aws_route" "internet_access" {
  id = var.aws_route_table_id
}

data "aws_security_group" "http_access" {
  id = var.aws_http_access_security_group_id
}
