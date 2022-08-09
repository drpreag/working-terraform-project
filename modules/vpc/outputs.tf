output "vpc" {
  value = aws_vpc.vpc
}

output "subnets-dmz" {
  value = tolist(aws_subnet.subnet-dmz)
}

output "azs-per-region" {
  value = local.azs-per-region
}
