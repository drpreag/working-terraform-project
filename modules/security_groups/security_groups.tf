
# SECURITY GROUPS

# Bastion sg
resource "aws_security_group" "bastion-sg" {
  name        = "${var.vpc-name}-${var.environment}-bastion"
  description = "Bastion security group"
  vpc_id      = var.vpc-id

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
  vpc_id      = var.vpc-id

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
    description = "HTTP from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ var.vpc-cidr ]
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
  vpc_id      = var.vpc-id

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
    from_port       = 80
    to_port         = 80
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

# Kubernetes sg
resource "aws_security_group" "k8s-sg" {
  name        = "${var.vpc-name}-${var.environment}-k8s"
  description = "Kubernetes worker nodes security group"
  vpc_id      = var.vpc-id

  ingress {
    description = "All from k8s"
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
    description     = "HTTP from LB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ var.vpc-cidr ]
  }
  tags = {
    Name = "${var.vpc-name}-${var.environment}-k8s-worker-nodes"
  }
}

# DB sg
resource "aws_security_group" "db-sg" {
  name        = "${var.vpc-name}-${var.environment}-db"
  description = "DB security group"
  vpc_id      = var.vpc-id

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
  vpc_id = var.vpc-id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}