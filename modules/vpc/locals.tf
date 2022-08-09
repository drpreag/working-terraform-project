
data "aws_region" "current" {}
data "aws_availability_zones" "available" { state = "available" }

locals {
  first-octet        = split(".", var.vpc-cidr)[0]
  second-octet       = split(".", var.vpc-cidr)[1]
  aws-region         = data.aws_region.current.name
  az                 = data.aws_availability_zones.available.names
  azs-per-region     = length(local.az)
}

