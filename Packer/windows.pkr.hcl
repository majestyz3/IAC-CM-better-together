# Packer template for Windows using Ansible

packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }

  hcp_packer_registry {
    bucket_name = "iac-cm-images"
    description = "Windows Server 2019 image for Ansible Tower demo"
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "windows" {
  region                  = var.region
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2019-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["801119661308"] # Microsoft
  }

  instance_type           = "t3.large"
  ssh_username            = "Administrator"
  ami_name                = "windows-server-2019-ansible-{{timestamp}}"

  communicator            = "winrm"
  winrm_username          = "Administrator"
  winrm_use_ssl           = true
  winrm_insecure          = true
  winrm_timeout           = "5m"
}

build {
  name    = "windows-ansible-image"
  sources = ["source.amazon-ebs.windows"]

  provisioner "powershell" {
    inline = [
      "Install-WindowsFeature -Name Web-Server",
      "Write-Output 'Windows AMI prepared.'"
    ]
  }
}
