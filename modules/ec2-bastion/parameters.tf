variable vpc-name {}
variable subnets {}
variable security-group {}
variable instance-type {}
variable key-name {}
variable environment {}
variable availability_zone {}

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

locals {
    ami     = data.aws_ami.aws_linux_image.id
}