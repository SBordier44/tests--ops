output "ec2_id" {
  value = aws_instance.ec2_docker.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2_docker.public_ip
}
