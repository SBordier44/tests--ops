variable "instance_name" {
  type        = string
  default     = "docker_instance"
  description = "Name of the EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Instance type for the EC2 instance"
}

variable "security_group_id" {
  type        = string
  default     = ""
  description = "Security group id for the EC2 instance"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
  default     = "ami-04df1508c6be5879e" // Ubuntu Server 24.04 Noble LTS HVM x86_64 EBS
}

variable "keypair_name" {
  type        = string
  description = "Key pair name for the EC2 instance"
  default     = "docker_ec2_keypair"
}
