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

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine."
  default     = "Standard_B2s"
  validation {
    condition     = contains(["Standard_B2s", "Standard_B2ms"], var.vm_size)
    error_message = "VM size must be Standard_B2s or Standard_B2ms."
  }
}

locals {
  tags = {
    cost-center = "azurevm"
    environment = "dev"
    team        = "briane"
    created-by  = "terraform"
  }
}
