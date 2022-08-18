
resource "aws_network_interface" "bastion-eni" {
  subnet_id         = aws_subnet.subnet-dmz[0].id
  source_dest_check = false

  tags = {
    Name = "${var.vpc-name}-${var.environment}-bastion-eni"
  }
}