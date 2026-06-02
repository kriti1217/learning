resource "azurerm_resource_group" "RG" {
    name     = var.resource_group_name
    location = var.location
  
}

resource "azurerm_virtual_network" "VNet" {
    name                = "myVNet"
    address_space       = var.address_space
    location            = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
}

resource "azurerm_subnet" "Subnet" {
    name                 = var.subnet_name
    resource_group_name  = azurerm_resource_group.RG.name
    virtual_network_name = azurerm_virtual_network.VNet.name
    address_prefixes     = var.subnet_prefix
}

resource "azurerm_public_ip" "public_ip" {
    name                = "${var.vm_name}-public-ip"
    location            = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    allocation_method   = "Dynamic"
  
}

resource "azurerm_network_interface" "nic" {
    name                = "${var.vm_name}-nic"
    location            = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
  
    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.Subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = azurerm_public_ip.public_ip.id
    }
  
}

resource "azurerm_virtual_machine" "VM" {
    name                  = var.vm_name
    location              = azurerm_resource_group.RG.location
    resource_group_name   = azurerm_resource_group.RG.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    vm_size               = var.vm_size
  
    storage_os_disk {
      name              = "${var.vm_name}-os-disk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
  
    storage_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
  
    os_profile {
      computer_name  = var.vm_name
      admin_username = var.admin_username
      admin_password = var.admin_password
    }
  
    os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
}

resource "azurerm_storage_account" "storage_account" {
    name                     = var.storage_account_name
    resource_group_name      = azurerm_resource_group.RG.name
    location                 = azurerm_resource_group.RG.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}



