output "vpc-id" {
  value = module.vpc.vpc.id
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

# output "bastion-ip" {
#   value = module.bastion.bastion-public-ip
# }

output "s3-bucket-arn" {
  value = module.s3.bucket.arn
}

output "route53-private-zone" {
  value = module.route53.route53-private-zone.name
}

output "route53-public-zone" {
  value = module.route53.route53-public-zone.name
}

output "kms-key-arn" {
  value = module.kms.kms-key.arn
}