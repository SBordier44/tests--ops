instance_type           = "t3.small"
security_group_ports    = [22, 8080, 8081, 8082, 8069, 30012, 30010, 30011, 6443]
security_group_protocol = "tcp"
security_group_name     = "sg_project"
stack_name              = "kubernetes" // kubernetes or docker (modules)
aws_region_name         = "eu-west-3"
