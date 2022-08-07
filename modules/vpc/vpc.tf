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

# SUBNETS

# in a case of /20 subnets use this:
# cidr_block        = "10.${local.second-octet}.${(XXX+count.index)*16}.0/20"

# DMZ subnets
resource "aws_subnet" "subnet-dmz" {
  count             = var.subnets-per-az
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.first-octet}.${local.second-octet}.${(0+count.index)*32}.0/19"
  availability_zone = "${var.aws-region}${var.az[count.index]}"
  tags = {
    Name = "${var.vpc-name}-${var.environment}-dmz-${var.az[count.index]}"
  }
}

# CORE subnets
resource "aws_subnet" "subnet-core" {
  count             = var.subnets-per-az
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.first-octet}.${local.second-octet}.${(2+count.index)*32}.0/19"
  availability_zone = "${var.aws-region}${var.az[count.index]}"
  tags = {
    Name = "${var.vpc-name}-${var.environment}-core-${var.az[count.index]}"
  }
}

# DATABASE subnets
resource "aws_subnet" "subnet-db" {
  count             = var.subnets-per-az
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.first-octet}.${local.second-octet}.${(4+count.index)*32}.0/19"
  availability_zone = "${var.aws-region}${var.az[count.index]}"
  tags = {
    Name = "${var.vpc-name}-${var.environment}-db-${var.az[count.index]}"
  }
}

# ROUTE TABLES

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc-name}-${var.environment}-public"
  }
}

resource "aws_default_route_table" "local" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    Name = "${var.vpc-name}-${var.environment}-local"
  }
}


# SUBNET ASSOCIATIONS to route tables

resource "aws_route_table_association" "dmz" {
  count          = var.subnets-per-az
  subnet_id      = aws_subnet.subnet-dmz[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "core" {
  count          = var.subnets-per-az
  subnet_id      = aws_subnet.subnet-core[count.index].id
  route_table_id = aws_default_route_table.local.id
}

resource "aws_route_table_association" "db" {
  count          = var.subnets-per-az
  subnet_id      = aws_subnet.subnet-db[count.index].id
  route_table_id = aws_default_route_table.local.id
}


# SECURITY GROUPS

# Bastion sg
resource "aws_security_group" "bastion-sg" {
  name        = "${var.vpc-name}-${var.environment}-bastion"
  description = "Bastion security group"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.company-ips
    content {
      description = "SSH from ${ingress.key}"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  ingress {
    description = "OpenVPN from everywhere"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Https from vpc, for updates"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc-name}-${var.environment}-bastion"
  }
}

# LB sg
resource "aws_security_group" "lb-sg" {
  name        = "${var.vpc-name}-${var.environment}-lb"
  description = "LB / HTTPS security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "All from lb"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  ingress {
    description     = "All from bastion"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.bastion-sg.id]
  }
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc-name}-${var.environment}-lb"
  }
}

# Core sg
resource "aws_security_group" "core-sg" {
  name        = "${var.vpc-name}-${var.environment}-core"
  description = "Core security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "All from core"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }
  ingress {
    description     = "HTTPS from LB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # or vpc.cidr_block to prevent go outside vpc
  }
  tags = {
    Name = "${var.vpc-name}-${var.environment}-core"
  }
}

# DB sg
resource "aws_security_group" "db-sg" {
  name        = "${var.vpc-name}-${var.environment}-db"
  description = "DB security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "All from db"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  ingress {
    description     = "Mysql from core"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.core-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc-cidr]
  }

  tags = {
    Name = "${var.vpc-name}-${var.environment}-db"
  }
}

# make default sg safe
resource "aws_default_security_group" "default" {
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
}