# Packer template for RHEL using Ansible provisioner

packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }

  hcp_packer_registry {
    bucket_name = "iac-cm-images"
    description = "Ubuntu golden image with Ansible integration"
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "ubuntu" {
  region                  = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }
  instance_type           = "t3.micro"
  ssh_username            = "ubuntu"
  ami_name                = "ubuntu-ansible-{{timestamp}}"
}

build {
  name    = "ubuntu-ansible-image"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-pip unzip",
    ]
  }
}

