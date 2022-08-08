output "bastion-sg" {
  value = aws_security_group.bastion-sg
}

output "security-groups" {
  value = tolist([aws_security_group.bastion-sg, aws_security_group.lb-sg, aws_security_group.core-sg, aws_security_group.db-sg])
}
