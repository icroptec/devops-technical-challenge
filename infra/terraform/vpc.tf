# vpc.tf
# Criação de uma VPC básica na AWS

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.project_name
  }
}
