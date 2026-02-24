resource "aws_eip" "eip_kubernetes" {
  domain = "vpc"
  tags = {
    Name = "${var.instance_name}-eip"
  }
}

resource "aws_instance" "ec2_kubernetes" {
  ami                         = var.ami_id
  key_name                    = var.keypair_name
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.security_group_id]
  user_data_replace_on_change = true
  user_data                   = file("./scripts/kubernetes.sh")

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  provisioner "local-exec" {
    command = "echo -e '\nansible_host: ${aws_eip.eip_kubernetes.public_ip}' >> ../04_ansible/host_vars/k3s.yml"
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2_kubernetes.id
  allocation_id = aws_eip.eip_kubernetes.id
}
