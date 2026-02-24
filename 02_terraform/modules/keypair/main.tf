resource "aws_key_pair" "keypair" {
  key_name   = var.keypair_name
  public_key = tls_private_key.tls_private_key.public_key_openssh
}

resource "tls_private_key" "tls_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_file" {
  content         = tls_private_key.tls_private_key.private_key_pem
  filename        = var.private_key_filename
  file_permission = "0400"
}
