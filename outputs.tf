# output "vpc-name" {
#   value = module.vpc
# }

output "bastion-instance" {
  value = module.bastion.bastion.public_ip
}
