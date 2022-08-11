output "vpc-id" {
  value = module.vpc.vpc-id
}

output "subnets-dmz" {
  value = module.vpc.subnets-dmz
}

output "subnets-core" {
  value = module.vpc.subnets-core
}

output "subnets-db" {
  value = module.vpc.subnets-db
}

