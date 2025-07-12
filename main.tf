resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.vm_name}"
  location = "West US 2"
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.allowed_rdp_ip
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  ip_version          = "IPv4"

  tags = local.tags
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm-${var.vm_name}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]
  license_type          = "Windows_Client"

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    name                   = "${var.vm_name}_OsDisk"
    disk_encryption_set_id = azurerm_disk_encryption_set.des.id // Enable disk encryption
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  patch_mode               = "AutomaticByOS"
  enable_automatic_updates = true

  depends_on = [
    azurerm_role_assignment.des_keyvault_crypto_user
  ]

  tags = local.tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id    = azurerm_windows_virtual_machine.vm.id
  location              = azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = var.shutdown_time
  timezone              = var.shutdown_time_timezone

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    # webhook_url     = ""
    email = var.shutdown_email
  }

  tags = local.tags
}

resource "azurerm_disk_encryption_set" "des" {
  name                = "des-${var.vm_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.kvk.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-${var.vm_name}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true

  tags = local.tags
}

resource "azurerm_key_vault_key" "kvk" {
  name         = "key-${var.vm_name}"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [
    azurerm_role_assignment.key_vault_admin
  ]

  tags = local.tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet {
    name             = "default"
    address_prefixes = ["10.0.0.0/24"]
    security_group   = azurerm_network_security_group.nsg.id
  }

  # Add a dedicated subnet for the VM for segmentation
  subnet {
    name             = "vm-subnet"
    address_prefixes = ["10.0.1.0/24"]
    security_group   = azurerm_network_security_group.nsg.id
  }

  tags = local.tags
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_virtual_network.vnet.subnet.*.id[1] // Attach to vm-subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address_version    = "IPv4"
  }

  tags = local.tags
}

resource "azurerm_role_assignment" "key_vault_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [
    azurerm_key_vault.kv
  ]
}

resource "azurerm_role_assignment" "des_keyvault_crypto_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des.identity[0].principal_id
}

output "vm_public_ip" {
  description = "The public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}