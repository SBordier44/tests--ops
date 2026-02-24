variable "security_group_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = list(string)
  description = "CIDR blocks to allow inbound traffic from"
}
variable "security_group_ports" {
  type        = list(number)
  description = "Ports to allow inbound traffic from"
  default     = []
}
variable "security_group_protocol" {
  type        = string
  description = "Protocol to allow inbound traffic from"
  default     = "tcp"
}
variable "security_group_name" {
  type        = string
  description = "Name of the security group"
  default     = ""
}
