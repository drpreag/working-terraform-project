# VPC
module "vpc" {
  source             = "./modules/vpc"
  aws-region         = var.aws-region
  vpc-name           = var.vpc-name
  vpc-cidr           = var.vpc-cidr
  subnets-per-az     = var.subnets-per-az
  az                 = var.az
  environment        = var.environment
  company-ips        = var.company-ips
}

module bastion {
  source            = "./modules/ec2-bastion"
  vpc-name          = var.vpc-name
  subnets           = module.vpc.subnets_dmz
  security-group    = module.vpc.bastion-sg
  instance-type     = var.bastion-instance-type
  key-name          = var.key-name
  environment       = var.environment
  availability_zone = "${var.aws-region}${var.az[0]}"
}