
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
  count          = var.az-count
  subnet_id      = aws_subnet.subnet-dmz[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "core" {
  count          = var.az-count
  subnet_id      = aws_subnet.subnet-core[count.index].id
  route_table_id = aws_default_route_table.local.id
}

resource "aws_route_table_association" "k8s" {
  count          = var.az-count
  subnet_id      = aws_subnet.subnet-k8s[count.index].id
  route_table_id = aws_default_route_table.local.id
}

resource "aws_route_table_association" "db" {
  count          = var.az-count
  subnet_id      = aws_subnet.subnet-db[count.index].id
  route_table_id = aws_default_route_table.local.id
}
