resource "azurerm_resource_group" "rg_name" {
    for_each = var.rg_name
    name = each.value.name
    location = each.value.location
}

resource "azurerm_virtual_network" "vnets" {
    for_each = var.vnets
    name = each.value.name
    address_space = each.value.address_space
    resource_group_name = azurerm_resource_group.rg_name[each.value.resource_group_name].name
    location = azurerm_resource_group.rg_name[each.value.resource_group_name].location
}

resource "azurerm_subnet" "subnets" {
    for_each = var.subnets
    name = each.value.name
    address_prefixes = each.value.a_p
    virtual_network_name = azurerm_virtual_network.vnets[each.value.v_n].name
    resource_group_name = azurerm_resource_group.rg_name[each.value.rg_n].name
}   


resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "b-pip"
  resource_group_name = azurerm_resource_group.rg_name["rg01"].name
  location            = azurerm_resource_group.rg_name["rg01"].location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastionhost"
  resource_group_name = azurerm_resource_group.rg_name["rg01"].name
  location            = azurerm_resource_group.rg_name["rg01"].location
  sku                 = "Standard"

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.subnets["subnet03"].id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}

resource "azurerm_virtual_network_peering" "peer01" {
    name                      = "vnet01-to-vnet02"
    resource_group_name       = azurerm_resource_group.rg_name["rg01"].name
    virtual_network_name      = azurerm_virtual_network.vnets["vnet01"].name
    remote_virtual_network_id = azurerm_virtual_network.vnets["vnet02"].id
    allow_forwarded_traffic   = true
   
}

resource "azurerm_virtual_network_peering" "peer02" {
    name                      = "vnet02-to-vnet01"
    resource_group_name       = azurerm_resource_group.rg_name["rg01"].name
    virtual_network_name      = azurerm_virtual_network.vnets["vnet02"].name
    remote_virtual_network_id = azurerm_virtual_network.vnets["vnet01"].id
    allow_forwarded_traffic   = true
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg01"
  location            = azurerm_resource_group.rg_name["rg01"].location
  resource_group_name = azurerm_resource_group.rg_name["rg01"].name
  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "22"

  }

  security_rule {
    name                       = "AllowRDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "8080"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each = var.subnets
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}   

resource "azurerm_network_interface" "nic" {
  for_each = var.nic
  name                = each.value.name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg_name[each.value.resource_group_name].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "VM" {
  for_each = var.VM
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg_name[each.value.resource_group_name].name
  location            = azurerm_resource_group.rg_name[each.value.resource_group_name].location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
 network_interface_ids = [
    azurerm_network_interface.nic[each.value.nic_name].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}