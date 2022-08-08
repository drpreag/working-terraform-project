# SUBNETS

# one of tihs cases
# cidr_block        = "${local.first-octet}.${local.second-octet}.${([0,8,16]+count.index)*1}.0/24" [max 8 az]
# cidr_block        = "${local.first-octet}.${local.second-octet}.${([0,8,16]+count.index)*8}.0/21" [max 8 az]
# cidr_block        = "${local.first-octet}.${local.second-octet}.${([0,4,8]+count.index)*16}.0/20" [max 4 az]
# cidr_block        = "${local.first-octet}.${local.second-octet}.${([0,2,4]+count.index)*32}.0/19" [max 2 az]

# DMZ subnets - public
resource "aws_subnet" "subnet-dmz" {
  count             = var.az-count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.first-octet}.${local.second-octet}.${(0 + count.index) * 32}.0/19"
  availability_zone = local.az[count.index]
  tags = {
    Name = "${var.vpc-name}-${var.environment}-dmz-${local.az[count.index]}"
  }
}


# CORE subnets
resource "aws_subnet" "subnet-core" {
  count             = var.az-count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.first-octet}.${local.second-octet}.${(2 + count.index) * 32}.0/19"
  availability_zone = local.az[count.index]
  tags = {
    Name = "${var.vpc-name}-${var.environment}-core-${local.az[count.index]}"
  }
}

# MISC subnets
resource "aws_subnet" "subnet-misc" {
  count             = var.az-count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.first-octet}.${local.second-octet}.${(4 + count.index) * 32}.0/19"
  availability_zone = local.az[count.index]
  tags = {
    Name = "${var.vpc-name}-${var.environment}-misc-${local.az[count.index]}"
  }
}


# DATABASE subnets
resource "aws_subnet" "subnet-db" {
  count             = var.az-count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.first-octet}.${local.second-octet}.${(6 + count.index) * 32}.0/19"
  availability_zone = local.az[count.index]
  tags = {
    Name = "${var.vpc-name}-${var.environment}-db-${local.az[count.index]}"
  }
}
