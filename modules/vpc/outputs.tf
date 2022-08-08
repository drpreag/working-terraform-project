output "vpc" {
  value = aws_vpc.vpc
}

output "subnets-dmz"{
  value = tolist(aws_subnet.subnet-dmz)
}
