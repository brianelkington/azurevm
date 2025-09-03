variable "vm_name" {
  type    = string
  default = "tempvm"
}

variable "nic_name" {
  type    = string
  default = "nic-tempvm535"
}

variable "public_ip_name" {
  type    = string
  default = "ip-tempvm"
}

variable "vnet_name" {
  type    = string
  default = "vnet-tempvm"
}

variable "nsg_name" {
  type    = string
  default = "nsg-tempvm"
}

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

variable "shutdown_email" {
  type        = string
  description = "Email address to send shutdown notifications."
}

variable "shutdown_time" {
  type        = string
  description = "Time to schedule the VM shutdown in UTC (e.g., '2200')."
  default     = "2200"
}

variable "shutdown_time_timezone" {
  type        = string
  description = "Timezone for the shutdown schedule (e.g., 'UTC')."
  default     = "Mountain Standard Time"
}

variable "allowed_rdp_ip" {
  description = "The public IP address allowed to RDP to the VM"
  type        = string
}

locals {
  tags = {
    cost-center = "azurevm"
    environment = "dev"
    team        = "briane"
    created-by  = "terraform"
  }
}
