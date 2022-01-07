resource "azurerm_kubernetes_cluster" "en1tstkk99aks" {
  name = "en1tstkk99aks"
  resource_group_name = azurerm_resource_group.example_resourcegroup.name
  location = azurerm_resource_group.example_resourcegroup.location
  dns_prefix = "en1tstkk99aks"

  default_node_pool {
    name = "en1tstkk9900"
    node_count = 1
    vm_size = "Standard_D2_v3"
  }
  
  identity {
    type = "SystemAssigned"
  }
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
  vm_size = "Standard_D2_v3"
  enable_auto_scaling = true
  node_count = 1
  max_count = 1
  max_pods = 30
}

