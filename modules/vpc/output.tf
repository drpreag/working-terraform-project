output "vpc" {
  value = aws_vpc.vpc
}

output "subnets_dmz"{
  value = tolist(aws_subnet.subnet-dmz)
}

output "bastion-sg"{
  value = aws_security_group.bastion-sg
}
