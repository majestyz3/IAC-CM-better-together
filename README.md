# Terraform + Ansible + Packer + Vault Demo

## Overview
This demo showcases how to use **Terraform**, **Ansible Tower**, **HCP Packer**, and **HCP Vault** together to provision and configure:

- A **RHEL-based Linux EC2 instance**
- A **Windows EC2 instance** hosted on **Red Hat OpenShift**

All infrastructure is deployed using **HCP Terraform**, configured using **Ansible Tower**, secured with **HCP Vault**, and built from golden images maintained in **HCP Packer**.

---

## 🔁 Workflow Diagram

```text
  GitHub (Code Repos)
        |
        | push
        v
+--------------------+
|  HCP Packer        |
|  (Build Images)    |
+--------------------+
        |
        | → AMI IDs
        v
+--------------------+
|  HCP Vault         |
|  (Secrets: AWS, Win)|
+--------------------+
        |
        | lookup
        v
+--------------------+
| HCP Terraform      |
| (Provision Infra)  |
+--------------------+
        |
        | → IPs, tags
        v
+--------------------+
| Ansible Tower      |
| (Post Config)      |
+--------------------+
```

---

## 🔧 Sub-Repositories

### 1. `iac-terraform-demo`
Contains all Terraform IaC files:
- AWS EC2 provisioning
- AMI lookups from HCP Packer
- Secrets pulled from HCP Vault

### 2. `packer-image-demo`
Builds hardened base images using:
- HCP Packer `amazon-ebs` builder
- Ansible provisioners for Linux and Windows

### 3. `cm-ansible-demo`
Ansible Tower playbooks and inventory:
- `linux.yml`, `windows.yml` for post-deploy config
- Terraform state-driven dynamic inventory
- Tower template config JSONs

---

## 🔐 Vault Secrets Required
Ensure the following secrets are stored in Vault KV:

- `kv/aws/creds`: `{ access_key, secret_key }`
- `kv/windows/admin`: `{ password }`

---

## 🚀 Launch Sequence

1. Run Packer builds:
   ```bash
   packer build linux.pkr.hcl
   packer build windows.pkr.hcl
   ```

2. Deploy Infra with Terraform:
   ```bash
   terraform init && terraform apply
   ```

3. Run Ansible playbooks via Tower:
   - Configure RHEL EC2
   - Configure Windows EC2

---

## 🧠 Notes
- RHEL image is based on official Red Hat AMIs (owner: `309956199498`)
- Windows image is Server 2022 (owner: `801119661308`)
- Ensure firewall and SSH/WinRM ports are open in your security group
- Make sure the SSH and WinRM credentials are injected via Vault and accessible to Tower
