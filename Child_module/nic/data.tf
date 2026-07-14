data "azurerm_subnet" "subnet_1" {
  for_each = var.nic_1
  name                 = each.value.ip_configuration.subnet_name
  virtual_network_name = each.value.ip_configuration.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
data "azurerm_public_ip" "public_ip_1" {
  for_each = var.nic_1
  name                = each.value.ip_configuration.public_ip_name
  resource_group_name = each.value.resource_group_name
}
