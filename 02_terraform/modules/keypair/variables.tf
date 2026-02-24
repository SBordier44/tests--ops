variable "private_key_filename" {
  description = "The filename to save the private key as"
  type        = string
  default     = "tls_private_key"
}

variable "keypair_name" {
  type        = string
  default     = "project-keypair"
  description = "Name of the keypair to create"
}
