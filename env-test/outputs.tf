output "vpc-id" {
  value = module.vpc.vpc-id
}

output "subnets-dmz" {
  value = module.vpc.subnets-dmz
}

output "subnets-core" {
  value = module.vpc.subnets-core
}

output "subnets-k8s" {
  value = module.vpc.subnets-k8s
}

output "subnets-db" {
  value = module.vpc.subnets-db
}

output "bastion-ip" {
  value = module.bastion.bastion-public-ip
}


