# Azure VM Terraform Deployment

This project uses [Terraform](https://www.terraform.io/) to provision a Windows Virtual Machine and supporting Azure resources in Azure. It includes an automatic daily shutdown schedule for cost savings.

## Resources Created

- Resource Group
- Virtual Network and Subnet
- Network Security Group (with RDP rule)
- Public IP Address
- Network Interface
- Windows Virtual Machine
- VM Auto-shutdown Schedule (8pm Mountain Time, with email notification)

## Prerequisites

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.12.2
- Azure subscription

## Usage

1. **Clone this repository** and navigate to the project directory.

2. **Configure your variables**  
   Edit `terraform.tfvars` with your Azure subscription ID, admin username, password, shutdown notification email, and shutdown time:
   ```hcl
   admin_username    = "your-username"
   admin_password    = "your-password"
   subscription_id   = "your-subscription-id"
   shutdown_email    = "your-email@example.com"
   shutdown_time     = "2000" # 8:00 PM in 24hr format
   shutdown_time_timezone = "Mountain Standard Time"