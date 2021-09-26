
resource "azurerm_public_ip" "publicIp1" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}publicIp1"
  location = var.GLOBAL_LOCATION
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  allocation_method = "Static"
  ip_version = "IPv4"

}


resource "azurerm_network_interface" "main_nic" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}nic"
  location = azurerm_resource_group.example_resourcegroup.location
  resource_group_name = azurerm_resource_group.example_resourcegroup.name

  ip_configuration {
    name = "${var.GLOBAL_RESOURCENAME_PREFIX}nic_ip"
    subnet_id = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicIp1.id
  }
  
}




resource "azurerm_virtual_machine" "vm1" {
  name = "${var.GLOBAL_RESOURCENAME_PREFIX}vm1"
  location = azurerm_resource_group.example_resourcegroup.location
  resource_group_name = azurerm_resource_group.example_resourcegroup.name

  network_interface_ids = [ azurerm_network_interface.main_nic.id ]
  vm_size = "Standard_B1s"


  storage_image_reference {
    publisher = "OpenLogic"
    offer = "Centos"
    sku = "7.5"
    version = "latest"
  }

  delete_os_disk_on_termination = false
  storage_os_disk {
    name = "${var.GLOBAL_RESOURCENAME_PREFIX}osdisk1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }



  

  os_profile {
    computer_name = "vm1"
    admin_username = "krasi"
    admin_password = "Krasi123"
    custom_data = data.template_file.userdata_vm1.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}


data "template_file" "userdata_vm1" {
  template = file("./userdata.tpl")
  vars = { }
}



output "vm_ip_priv" {
  value = azurerm_network_interface.main_nic.private_ip_address
}

output "vm_ip_pub" {
  value = azurerm_public_ip.publicIp1.ip_address
}