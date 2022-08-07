variable "aws-region" {}
variable "vpc-name" {}
variable "vpc-cidr" {}
variable "subnets-per-az" {}
variable "az" {}
variable "environment" {}
variable "company-ips" {}

locals {
    first-octet     = split(".", var.vpc-cidr)[0]
    second-octet    = split(".", var.vpc-cidr)[1]
}

