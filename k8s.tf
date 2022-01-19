# resource "azurerm_subnet" "subnet_aks" {
#   name = "${var.GLOBAL_RESOURCENAME_PREFIX}subnet_aks"
#   resource_group_name = azurerm_resource_group.example_resourcegroup.name
#   virtual_network_name = azurerm_virtual_network.bde_test_vnet.name
#   address_prefixes = [ var.GLOBAL_VNET_SUBNETS.aks ]
# }

# resource "azurerm_network_security_group" "main_aks" {
#   name = "${var.GLOBAL_RESOURCENAME_PREFIX}sg_aks"
#   location = azurerm_resource_group.example_resourcegroup.location
#   resource_group_name = azurerm_resource_group.example_resourcegroup.name
# }


# resource "azurerm_network_security_rule" "name" {
#   name = "${var.GLOBAL_RESOURCENAME_PREFIX}sg_aks_rule_main"
#   network_security_group_name = azurerm_network_security_group.main_aks.name
#   resource_group_name = azurerm_resource_group.example_resourcegroup.name
#   priority = 150
#   direction = "Inbound"
#   access = "Allow"
#   protocol = "Tcp"
#   source_port_range = "*"
#   destination_port_range = "443"
#   source_address_prefix = "*"
#   destination_address_prefixes = flatten([azurerm_subnet.subnet_aks.address_prefixes])
# }


resource "azurerm_kubernetes_cluster" "en1tstkk99aks" {
  name = "en1tstkk99aks"
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  location = azurerm_resource_group.example_resourcegroup.location
  dns_prefix = "en1tstkk99aks"

  default_node_pool {
    name = "en1tstkk9900"
    node_count = 1
    vm_size = "Standard_D2_v3"
    # vnet_subnet_id = azurerm_subnet.subnet_aks.id
  }
  
  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr = var.GLOBAL_VNET_SUBNETS.aks
    dns_service_ip = "10.0.79.250"
    docker_bridge_cidr = "10.0.79.200"
    load_balancer_sku = "Standard"
  }

  node_resource_group = var.k8s_nodes_resource_group_name
}

data "azurerm_resource_group" "k8snodes_rg" {
  name = var.k8s_nodes_resource_group_name
  depends_on = [
    azurerm_kubernetes_cluster.en1tstkk99aks
  ]
}

resource "azurerm_public_ip" "k8sIngressIp" {
  name = "k8sIngressIp"
  location = data.azurerm_resource_group.k8snodes_rg.location
  resource_group_name = var.k8s_nodes_resource_group_name # k8s nodes resource group name; and it's location should match cluster resource group's location
  allocation_method = "Static"
  ip_version = "IPv4"
  sku = "Standard"
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.en1tstkk99aks.kube_config_raw
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.en1tstkk99aks.kube_config_raw
  sensitive = true
}


resource "azurerm_kubernetes_cluster_node_pool" "en1tstkk9901" {
  name = "en1tstkk9901"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.en1tstkk99aks.id
  # vnet_subnet_id = azurerm_subnet.subnet_aks.id
  vm_size = "Standard_D2_v3"
  enable_auto_scaling = true
  min_count = 1
  max_count = 1
  max_pods = 30
}

resource "null_resource" "k8s-kubeconfig-output" {
  provisioner "local-exec" {
    command = local.kubeConfigCmd
  }
  triggers = {
    kubeconfig = md5(azurerm_kubernetes_cluster.en1tstkk99aks.kube_config_raw)
    # kubeconfig = md5(timestamp())
  }

  depends_on = [
    azurerm_kubernetes_cluster.en1tstkk99aks
  ]
}

locals {
  kubeConfigCmd = <<EOF
cat <<ECAT > ${var.k8s_kubeconfig}
${azurerm_kubernetes_cluster.en1tstkk99aks.kube_config_raw}
ECAT
EOF
}