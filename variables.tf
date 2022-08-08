# Make only changes to this file only, do not hardcode any parameter to main.tf
#
# This terraform repository creates:
#
#         VPC with IGW, subnets, route tables, NACLs and security groups
#         Instance IAM role / profile
#         KMS key
#         Bastion instance
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
variable "az-count" {
    # for /19 subnets max 2
    # for /21 and /24 subnets max 8, also depends on region
    description = "Number of Availability Zones to use (min 1, max depends of a region)"
    default     = 1
    type        = number
}
variable "key-name" { default = "drpreag_2021" }

# Instance types
variable "bastion-instance-type" { default = "t3a.micro" }
variable "core-instance-type" { default = "t3a.micro" }
variable "rds-instance-type" { default = "db.t3.micro" }

# for whitelisting IPs on SG for SSH on bastion host
variable "company-ips" {
  type = map(any)
  default = {
    "Predrag home 1" = "46.235.98.0/24"
    "Predrag home 2" = "46.235.99.0/24"
  }
}
