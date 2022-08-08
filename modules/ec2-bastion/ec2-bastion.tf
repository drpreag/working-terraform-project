
# EC2 instance

resource "aws_instance" "bastion" {
  ami                       = local.ami
  availability_zone         = local.az[0]
  subnet_id                 = var.subnets[0].id
  instance_type             = var.instance-type
  vpc_security_group_ids    = [ var.security-group.id ]
  key_name                  = var.key-name
#   iam_instance_profile    = var.instance_profile
  associate_public_ip_address = true
  disable_api_termination = false
  ebs_optimized           = false
  hibernation             = false
  source_dest_check       = false
  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }
  credit_specification {
    cpu_credits = "standard"
  }
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname "${var.vpc-name}-${var.environment}-bastion"
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    service iptables save
    yum check-update
    EOF
  tags = {
    Name = "${var.vpc-name}-${var.environment}-bastion"
  }
  provisioner "local-exec" {
    command = "echo \"Bastion Public IP: ${self.public_ip}\""
  }
}