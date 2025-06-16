resource "azurerm_resource_group" "rg" {
  name     = "rg-tempvm"
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
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    "created-by" = "Manual"
  }
}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  ip_version          = "IPv4"

  tags = {
    "created-by" = "Manual"
  }
}

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

  tags = {
    "created-by" = "Manual"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_virtual_network.vnet.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address_version    = "IPv4"
  }

  tags = {
    "created-by" = "Manual"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]
  license_type          = "Windows_Client"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.vm_name}_OsDisk"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }

  tags = {
    "created-by" = "Manual"
  }
}

# resource "azurerm_dev_test_schedule" "shutdown" {
#   name                = var.shutdown_schedule_name
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   lab_name            = "devtestvmlab"
#   task_type           = "ComputeVmShutdownTask"
#   status              = "Enabled"
#   time_zone_id        = "Mountain Standard Time"
#   daily_recurrence {
#     time = "1900"
#   }
#   notification_settings {
#     status          = "Enabled"
#     time_in_minutes = 30
#   }
# }
