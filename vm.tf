
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
    admin_username = var.vm1_host_user
    admin_password = var.vm1_host_password
    # custom_data = data.template_file.userdata_vm1.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path = "/home/krasi/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAg3RTH8uWUOwIrBkwY/RRfFeqo6pqrgYNy/891gvNw4ZdoRtUAMPyUsIrjnrzCB4DdG4093U/mCKGKfb0dv4tKOUuV6k4wtdU6pzQ6E4dsZE0anqcuDKnp9/jwkEKWkxXCwIfQJmvW4odFqV0+Bnr4O1AfwuI/EQscXesJTRd+Nmafho/NXwS8L4qTFY7HTi0AQFeBKANP9oqRc4xkkCPYVhbtglnETQTKJDjp91D0PZqkWihDRtKsoV7jLp4ehBX+JryJBQdXAhnfDH+Hqc+Gt9iUR+pUei1KGNPPz0oVy50Qq5IfG3P3YnQ78IRifew4VSLVOEJQxnOda0xcRhSzmoHlhV2mE0zc2UXnaOds4953BnjJ31BvA/zVg2FmnBpnhvwZFSdgfXjSrdIf12fk7IaN9Y/TAtFaSj4gWfr6zfqXBv+IuQ6k3qlGbgjfZ71CESw9jKJu+TppjqPcVVw34nuadoFx4jlV2T572K+HbPhqf0u+yaYeWHL0u0V7tc= krasimir.koev@BGGLOBAL9696"
    }
  }
}


data "template_file" "userdata_vm1" {
  template = file("./userdata.tpl")
  vars = {
    password = var.vm1_host_password
  }
}



output "vm_ip_priv" {
  value = azurerm_network_interface.main_nic.private_ip_address
}

output "vm_ip_pub" {
  value = azurerm_public_ip.publicIp1.ip_address
}



resource "null_resource" "provision" {

  connection {
    host = azurerm_public_ip.publicIp1.ip_address
    type = "ssh"
    password = var.vm1_host_password
    user = var.vm1_host_user
  }

  provisioner "file" {
    content = data.template_file.userdata_vm1.rendered
    destination = "~/userdata.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod u+x ~/userdata.sh",
      "~/userdata.sh"
    ]
  }

}


resource "null_resource" "local" {
  provisioner "local-exec" {
    command = join("\n", local.exec)
  }
  triggers = {
    "t1" = md5(join("\n", local.exec))
  }
}

locals {
  exec = [
        "echo a",
        "echo b",
        "echo c"
      ]
}