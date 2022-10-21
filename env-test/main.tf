
module "vpc" {
  source      = "git::https://github.com/drpreag/terraform-modules.git//vpc?ref=master"
  vpc-name    = var.vpc-name
  vpc-cidr    = var.vpc-cidr
  az-count    = var.az-count
  environment = var.environment
  company-ips = var.company-ips
}

module "sg" {
  source      = "git::https://github.com/drpreag/terraform-modules.git//security_groups?ref=master"
  vpc-id      = module.vpc.vpc.id
  environment = var.environment
  company-ips = var.company-ips
}

# module "bastion" {
#   source         = "git::https://github.com/drpreag/terraform-modules.git//ec2-bastion?ref=master"
#   eni            = module.vpc.bastion-eni
#   vpc-name       = var.vpc-name
#   security-group = module.sg.security-groups[0]
#   instance-type  = var.bastion-instance-type
#   key-name       = var.key-name
#   environment    = var.environment
# }

module "route53" {
  source      = "git::https://github.com/drpreag/terraform-modules.git//route53?ref=master"
  vpc-id      = module.vpc.vpc.id
  zone-name   = "it-outsource.me"
  environment = var.environment
}

module "kms" {
  source      = "git::https://github.com/drpreag/terraform-modules.git//kms?ref=master"
  vpc-id      = module.vpc.vpc.id
  environment = var.environment
}

module "s3" {
  source          = "git::https://github.com/drpreag/terraform-modules.git//s3?ref=master"
  vpc-id          = module.vpc.vpc.id
  allowed-origins = "https://it-outsource.me"
  bucket-name     = "it-outsource-test-bucket"
}
