
# latest Amazon AMI linux 2 image in current region
data "aws_ami" "aws_linux_image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" { state = "available" }

locals {
  ami             = data.aws_ami.aws_linux_image.id
  aws-region      = data.aws_region.current.name
  az              = data.aws_availability_zones.available.names
}
