resource "aws_security_group" "security_group" {
  name = var.security_group_name
  dynamic "ingress" {
    for_each = var.security_group_ports
    content {
      protocol    = var.security_group_protocol
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = var.security_group_cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.security_group_name
  }
}
