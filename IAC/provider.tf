terraform {
  required_version = ">= 1.4"
  cloud {
    organization = "your-org"
    workspaces {
      name = "terraform-ansible-demo"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = ">= 3.0"
    }
    packer = {
      source = "hashicorp/packer"
      version = ">= 1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}