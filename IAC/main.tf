# Root Terraform configuration for deploying infrastructure
# This includes a RHEL Linux EC2 instance and an OpenShift cluster for Windows VM
# Secrets pulled from HCP Vault, AMIs pulled from HCP Packer



# Retrieve latest AMI from HCP Packer channel for RHEL Linux
data "hcp_packer_image" "linux" {
  bucket_name = "demo-images"
  channel     = "latest"
  platform    = "aws"
  region      = var.aws_region
  os          = "rhel"
}

# Retrieve latest AMI from HCP Packer channel for Windows
data "hcp_packer_image" "windows" {
  bucket_name = "demo-images"
  channel     = "latest"
  platform    = "aws"
  region      = var.aws_region
  os          = "windows"
}

# Pull secrets from Vault
data "vault_kv_secret_v2" "aws_creds" {
  mount = "kv"
  name  = "aws/creds"
}

data "vault_kv_secret_v2" "windows_admin" {
  mount = "kv"
  name  = "windows/admin"
}

# RHEL Linux EC2 instance
resource "aws_instance" "linux" {
  ami           = data.hcp_packer_image.linux.cloud_image_id
  instance_type = "t3.micro"
  tags = {
    Name = "Linux-Demo"
    Role = "Ansible-Managed"
  }
}

# Windows OpenShift placeholder
resource "aws_instance" "windows" {
  ami           = data.hcp_packer_image.windows.cloud_image_id
  instance_type = "t3.large"
  tags = {
    Name = "Windows-Demo"
    Role = "OpenShift-Windows"
  }
  user_data = file("../ansible/playbooks/windows_setup.ps1")
}


