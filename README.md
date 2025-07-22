# Azure VM Terraform Deployment

This project uses [Terraform](https://www.terraform.io/) to provision a Windows Virtual Machine and supporting Azure resources in Azure. It includes security best practices such as disk encryption, managed identities, network segmentation, RBAC, and an automatic daily shutdown schedule for cost savings.

## Resources Created

- Resource Group
- Virtual Network with Segmented Subnets (`default`, `vm-subnet`)
- Network Security Group (with RDP rule restricted to your IP)
- Public IP Address
- Network Interface (attached to `vm-subnet`)
- Windows Virtual Machine (with managed identity, disk encryption, and automatic updates)
- Key Vault and Key for disk encryption
- Disk Encryption Set
- Storage Account with `data` blob container and file share (protected from destroy)
- VM Auto-shutdown Schedule
- RBAC role assignments for secure access

## Prerequisites

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.12.2
- Azure subscription with sufficient permissions (Contributor, Key Vault Administrator)

## Usage

1. **Clone this repository** and navigate to the project directory.
2. **Configure your variables**
   Edit `terraform.tfvars` with your Azure subscription ID, admin username, password, shutdown notification email, and your public IP for RDP access:
   ```hcl
   admin_username  = "your-username"
   admin_password  = "your-password"
   subscription_id = "your-subscription-id"
   shutdown_email  = "your-email@example.com"
   allowed_rdp_ip  = "YOUR.PUBLIC.IP.ADDRESS" # e.g., "203.0.113.45"
   ```
3. **Deploy the infrastructure**
   ```bash
   terraform init
   terraform apply
   ```
   The VM will automatically map the `data` share to the `D:` drive.
