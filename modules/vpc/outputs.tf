output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "subnets-dmz" {
  value = tolist([for s in aws_subnet.subnet-dmz : s.id])
}

output "subnets-core" {
  value = tolist([for s in aws_subnet.subnet-core : s.id])
}

output "subnets-k8s" {
  value = tolist([for s in aws_subnet.subnet-k8s : s.id])
}

output "subnets-db" {
  value = tolist([for s in aws_subnet.subnet-db : s.id])
}
