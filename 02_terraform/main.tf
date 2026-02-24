data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] // Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

locals {
  ami_id               = data.aws_ami.ubuntu.id
  private_key_filename = "./keypair/${var.stack_name}.pem"
  instance_name        = var.stack_name
}

module "keypair" {
  source               = "./modules/keypair"
  keypair_name         = var.stack_name
  private_key_filename = local.private_key_filename
}

module "security_group" {
  source                  = "./modules/security_group"
  security_group_ports    = var.security_group_ports
  security_group_protocol = var.security_group_protocol
  security_group_name     = var.security_group_name
}

module "ec2_docker" {
  source            = "./modules/docker"
  ami_id            = local.ami_id
  keypair_name      = var.stack_name
  security_group_id = module.security_group.security_group_id
  instance_name     = local.instance_name
  instance_type     = var.instance_type
  count             = var.stack_name == "docker" ? 1 : 0
  depends_on        = [module.keypair, module.security_group]
}

module "ec2_kubernetes" {
  source            = "./modules/kubernetes"
  ami_id            = local.ami_id
  keypair_name      = var.stack_name
  security_group_id = module.security_group.security_group_id
  instance_name     = local.instance_name
  instance_type     = var.instance_type
  count             = var.stack_name == "kubernetes" ? 1 : 0
  depends_on        = [module.keypair, module.security_group]
}
