# Packer template for Windows using Ansible

source "amazon-ebs" "windows" {
  region                  = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
  instance_type           = "t3.large"
  ami_name                = "demo-windows-ansible-{{timestamp}}"
  communicate_method      = "winrm"
  winrm_username          = "Administrator"
  winrm_insecure          = true
  winrm_use_ssl           = false
  winrm_timeout           = "10m"
  tags = {
    Role = "Base-Windows"
  }
}

build {
  name    = "windows-image"
  sources = ["source.amazon-ebs.windows"]

  provisioner "ansible" {
    playbook_file = "ansible/playbooks/packer_windows.yml"
  }
}
