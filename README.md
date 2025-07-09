# Azure VM Terraform Deployment

This project uses [Terraform](https://www.terraform.io/) to provision a Windows Virtual Machine and supporting Azure resources.

## Resources Created

- Resource Group
- Virtual Network and Subnet
- Network Security Group (with RDP rule)
- Public IP Address
- Network Interface
- Windows Virtual Machine

## Prerequisites

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.12.2
- Azure subscription

## Usage

1. **Clone this repository** and navigate to the project directory.

2. **Configure your variables**  
   Edit `terraform.tfvars` with your Azure subscription ID, admin username, and password:
   ```hcl
   admin_username  = "your-username"
   admin_password  = "your-password"
   subscription_id = "your-subscription-id"