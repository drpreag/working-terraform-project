output "bastion-id" {
  value = aws_instance.bastion.id
}

output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}