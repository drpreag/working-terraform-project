# Make only to this file only, do not hardcode any parameter to main.tf
#
# This terraform repository creates:
#
#         VPC with IGW, subnets, route tables, NACLs and security groups
#         Instance IAM role / profile
#         KMS key
#         R53 records
#
# Author Predrag Vlajkovic 2022
#

variable "aws-region" {
  default = "us-east-1"
  type = string
}
variable "bucket-state" { default = "imosoft-terraform-state" }
variable "vpc-name" { default = "noname" }
variable "vpc-cidr" {
  description = "VPC CIDR range in form: 10.XXX.0.0/16"
  default = "10.0.0.0/16"
}
variable "environment" {
  description = "Environment in which we deploy"
  default = "development"
}

# How many subnet per AZ to create
# for /20 subnets max 4 (but depends of number of zones in a region)
# for /19 subnets max 2
variable "subnets-per-az" {
  default = 1
  type = number
}

# variable "subnets-cidr-blocks" {
#   default = [
#     "10.", "", "", ""
#   ]
# }

variable "key-name" { default = "drpreag_2021" }

# Instance types
variable "bastion-instance-type" { default = "t3a.micro" }
variable "core-instance-type" { default = "t3a.micro" }
variable "rds-instance-type" { default = "db.t3.micro" }

# Core autoscaling group
variable "desired-capacity" { default = 0 }
variable "max-size" { default = 0 }
variable "min-size" { default = 0 }

# for whitelisting IPs on SG for SSH on bastion host
variable "company-ips" {
  type = map(any)
  default = {
    "Predrag home" = "46.235.98.0/24"
  }
}

# available AZ's
variable az { default = [ "a", "b", "c", "d", "e", "f" ] }

locals {
  first-octet     = split(".", var.vpc-cidr)[0]
  second-octet    = split(".", var.vpc-cidr)[1]
}
