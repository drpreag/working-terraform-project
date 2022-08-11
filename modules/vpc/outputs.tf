output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "subnets-dmz" {
  # value = tolist(aws_subnet.subnet-dmz.id)
  value = tolist([for s in aws_subnet.subnet-dmz : s.id])
}

output "subnets-core" {
  # value = tolist(aws_subnet.subnet-core.id)
  value = tolist([for s in aws_subnet.subnet-core : s.id])
}

output "subnets-db" {
  # value = tolist(aws_subnet.subnet-db.id)
  value = tolist([for s in aws_subnet.subnet-db : s.id])
}

# output "azs-per-region" {
#   value = local.azs-per-region
# }
