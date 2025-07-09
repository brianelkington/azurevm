# Azure VM Terraform Deployment

This project uses [Terraform](https://www.terraform.io/) to provision a Windows Virtual Machine and supporting Azure resources in Azure. It includes security best practices such as disk encryption, managed identities, network segmentation, and an automatic daily shutdown schedule for cost savings.

## Resources Created

- Resource Group
- Virtual Network with Segmented Subnets (`default`, `vm-subnet`)
- Network Security Group (with RDP rule)
- Public IP Address
- Network Interface (attached to `vm-subnet`)
- Windows Virtual Machine (with managed identity, disk encryption, and automatic updates)
- Key Vault and Key for disk encryption
- Disk Encryption Set
- VM Auto-shutdown Schedule (8pm Mountain Time, with email notification)
- RBAC role assignments for secure access

## Prerequisites

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.12.2
- Azure subscription with sufficient permissions (Contributor, Key Vault Administrator)

## Usage

1. **Clone this repository** and navigate to the project directory.

2. **Configure your variables**  
   Edit `terraform.tfvars` with your Azure subscription ID, admin username, password, shutdown notification email, and other required values:
   ```hcl
   admin_username    = "your-username"
   admin_password    = "your-password"
   subscription_id   = "your-subscription-id"
   shutdown_email    = "your-email@example.com"