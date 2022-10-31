
module "vpc" {
  source      = "git::https://github.com/drpreag/terraform-modules.git//vpc?ref=1.0.0"
  vpc-name    = var.vpc-name
  vpc-cidr    = var.vpc-cidr
  az-count    = var.az-count
  environment = var.environment
  company-ips = var.company-ips
}

module "sg" {
  source      = "git::https://github.com/drpreag/terraform-modules.git//security_groups?ref=1.0.0"
  vpc-id      = module.vpc.vpc.id
  environment = var.environment
  company-ips = var.company-ips
}

# module "bastion" {
#   source         = "git::https://github.com/drpreag/terraform-modules.git//ec2-bastion?ref=1.0.0"
#   eni            = module.vpc.bastion-eni
#   vpc-name       = var.vpc-name
#   security-group = module.sg.security-groups[0]
#   instance-type  = var.bastion-instance-type
#   key-name       = var.key-name
#   environment    = var.environment
# }

module "route53" {
  source      = "git::https://github.com/drpreag/terraform-modules.git//route53?ref=1.0.0"
  vpc-id      = module.vpc.vpc.id
  zone-name   = "wtf.com"
  environment = var.environment
}

# module "kms" {
#   source      = "git::https://github.com/drpreag/terraform-modules.git//kms?ref=1.0.0"
#   vpc-id      = module.vpc.vpc.id
#   environment = var.environment
# }

module "s3" {
  source          = "git::https://github.com/drpreag/terraform-modules.git//s3?ref=1.0.0"
  vpc-id          = module.vpc.vpc.id
  allowed-origins = "https://wtf.com"
  bucket-name     = "wtf-com-test-bucket"
}
