resource "azurerm_virtual_network" "bde_test_vnet" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}vnet"
  location = azurerm_resource_group.example_resourcegroup.location
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  address_space = [ var.GLOBAL_VNET_CIDR ]
  dns_servers = [ var.GLOBAL_DNS_SERVERS.a, var.GLOBAL_DNS_SERVERS.b, var.GLOBAL_DNS_SERVERS.c,  ]

}


resource "azurerm_subnet" "subnet_1" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}subnet1"
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  virtual_network_name = azurerm_virtual_network.bde_test_vnet.name
  address_prefixes = [ var.GLOBAL_VNET_SUBNETS.a ]
}




resource "azurerm_subnet" "subnet_2" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}subnet2"
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  virtual_network_name = azurerm_virtual_network.bde_test_vnet.name
  address_prefixes = [ var.GLOBAL_VNET_SUBNETS.b ]
}

resource "azurerm_subnet" "subnet_11" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}subnet11"
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  virtual_network_name = azurerm_virtual_network.bde_test_vnet.name
  address_prefixes = [ var.GLOBAL_VNET_SUBNETS.x ]
}

resource "azurerm_subnet" "subnet_12" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}subnet12"
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  virtual_network_name = azurerm_virtual_network.bde_test_vnet.name
  address_prefixes = [ var.GLOBAL_VNET_SUBNETS.y ]
}


resource "azurerm_network_security_group" "main_sg" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}sg_main"
  location = var.GLOBAL_LOCATION
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
}


resource "azurerm_network_security_rule" "rule80" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}rule80_ext"
  priority = 150
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "80"
  source_address_prefix = "*"
  destination_address_prefixes = flatten([azurerm_subnet.subnet_1.address_prefixes,  azurerm_subnet.subnet_2.address_prefixes])
  network_security_group_name = azurerm_network_security_group.main_sg.name
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
}

