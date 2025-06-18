variable "vm_name" {
  type    = string
  default = "tempvm"
}

variable "nic_name" {
  type    = string
  default = "tempvm535"
}

variable "public_ip_name" {
  type    = string
  default = "tempvm-ip"
}

variable "vnet_name" {
  type    = string
  default = "tempvm-vnet"
}

variable "nsg_name" {
  type    = string
  default = "tempvm-nsg"
}

# variable "shutdown_schedule_name" {
#   type    = string
#   default = "shutdown-computevm-tempvm"
# }

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "admin_username" {
  type = string
  # default = "ad"
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

locals {
  tags = {
    cost-center = "azurevm"
    environment = "dev"
    team        = "briane"
    created-by  = "terraform"
  }
}
