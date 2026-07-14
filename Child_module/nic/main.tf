variable "nic_1" {
  
}

resource "azurerm_network_interface" "nic_1" {
    for_each = var.nic_1
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration.name
    subnet_id                     = data.azurerm_subnet.subnet_1[each.key].id
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    public_ip_address_id          = data.azurerm_public_ip.public_ip_1[each.key].id
  }
}

