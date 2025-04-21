# Packer template for RHEL using Ansible provisioner

source "amazon-ebs" "rhel" {
  region                  = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "RHEL-8.*-x86_64-*-Hourly2-GP2"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["309956199498"]
    most_recent = true
  }
  instance_type           = "t3.micro"
  ssh_username            = "ec2-user"
  ami_name                = "demo-rhel-ansible-{{timestamp}}"
  associate_public_ip_address = true
  tags = {
    Role = "Base-RHEL"
  }
}

build {
  name    = "rhel-image"
  sources = ["source.amazon-ebs.rhel"]

  provisioner "ansible" {
    playbook_file = "ansible/playbooks/packer_linux.yml"
  }
}
