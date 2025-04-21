variable "aws_region" {
  default = "us-east-1"
}

variable "vault_address" {
  description = "Address for Vault instance"
  type        = string
}

variable "vault_token" {
  description = "Vault token to authenticate"
  type        = string
  sensitive   = true
}