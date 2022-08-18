
module "vpc" {
  source      = "../modules/vpc"
  vpc-name    = var.vpc-name
  vpc-cidr    = var.vpc-cidr
  az-count    = var.az-count
  environment = var.environment
  company-ips = var.company-ips
}

module "sg" {
  source      = "../modules/security_groups"
  vpc-id      = module.vpc.vpc-id
  vpc-name    = var.vpc-name
  vpc-cidr    = var.vpc-cidr
  environment = var.environment
  company-ips = var.company-ips
}

module "bastion" {
  source         = "../modules/ec2-bastion"
  eni            = module.vpc.bastion-eni
  vpc-name       = var.vpc-name
  security-group = module.sg.security-groups[0]
  instance-type  = var.bastion-instance-type
  key-name       = var.key-name
  environment    = var.environment
}
