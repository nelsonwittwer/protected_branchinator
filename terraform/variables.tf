variable "container_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nelsonwittwer/protected_branchinator_docker:latest"
}

variable "container_count" {
  description = "Number of Docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "aws_vpc_id" {
  description = "ID for existing AWS VPC"
  default     = "vpc-0fb489da59bb4c952"
}

variable "aws_public_subnet_id" {
  description = "ID for existing AWS public subnet"
  default     = "subnet-0e03b92cd3a7cd028"
}

variable "aws_internet_gateway_id" {
  description = "ID for existing AWS internet gateway"
  default     = "igw-0707f9b84b70d50cf"
}

variable "aws_route_table_id" {
  description = "ID for existing AWS route table"
  default     = "rtb-0f550444184005fd3"
}

variable "aws_http_access_security_group_id" {
  description = "ID for existing AWS security group for HTTP ingress"
  default     = "sg-0bf812882147107b9"
}
