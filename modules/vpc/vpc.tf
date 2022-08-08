
# VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc-name}-${var.environment}"
  }
  provisioner "local-exec" {
    command = "echo \"VPC: ${self.id}\""
  }
}


# IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc-name}-${var.environment}-igw"
  }
}
