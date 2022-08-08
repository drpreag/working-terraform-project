
variable "vpc-name" {}
variable "vpc-cidr" {}
variable "az-count" {
    description = "Number of Availability Zones to use (min 1, max depends of a region)"
    default = 1
}
variable "environment" {}
variable "company-ips" {}

