# ─── Resource Group ───────────────────────────────────────────────────────────
resource "azurerm_resource_group" "aro" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ─── Service Principal para o ARO ─────────────────────────────────────────────
resource "azuread_application" "aro" {
  display_name = "sp-${var.cluster_name}"
}

resource "azuread_service_principal" "aro" {
  client_id = azuread_application.aro.client_id
}

resource "random_password" "sp_secret" {
  length  = 32
  special = true
}

resource "azuread_application_password" "aro" {
  application_id = azuread_application.aro.id
  display_name   = "aro-sp-secret"
  end_date       = "2027-01-01T00:00:00Z"
}

# Role Assignment: Contributor no Resource Group
resource "azurerm_role_assignment" "aro_contributor" {
  scope                = azurerm_resource_group.aro.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aro.object_id
}

# ─── Registro do provider Microsoft.RedHatOpenShift ───────────────────────────
resource "azurerm_resource_provider_registration" "aro" {
  name = "Microsoft.RedHatOpenShift"
}

# ─── Virtual Network ──────────────────────────────────────────────────────────
resource "azurerm_virtual_network" "aro" {
  name                = "vnet-${var.cluster_name}"
  location            = azurerm_resource_group.aro.location
  resource_group_name = azurerm_resource_group.aro.name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

# Subnet dos Masters
resource "azurerm_subnet" "master" {
  name                 = "snet-master"
  resource_group_name  = azurerm_resource_group.aro.name
  virtual_network_name = azurerm_virtual_network.aro.name
  address_prefixes     = [var.master_subnet_cidr]

  # Necessário para o ARO
  service_endpoints = ["Microsoft.ContainerRegistry"]

  private_link_service_network_policies_enabled = false
}

# Subnet dos Workers
resource "azurerm_subnet" "worker" {
  name                 = "snet-worker"
  resource_group_name  = azurerm_resource_group.aro.name
  virtual_network_name = azurerm_virtual_network.aro.name
  address_prefixes     = [var.worker_subnet_cidr]

  service_endpoints = ["Microsoft.ContainerRegistry"]
}

# ─── Role no ARO Resource Provider (obrigatório) ──────────────────────────────
data "azuread_service_principal" "aro_rp" {
  display_name = "Azure Red Hat OpenShift RP"
}

resource "azurerm_role_assignment" "aro_rp_network" {
  scope                = azurerm_virtual_network.aro.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.aro_rp.object_id
}

resource "azurerm_role_assignment" "sp_network" {
  scope                = azurerm_virtual_network.aro.id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.aro.object_id
}

# ─── Cluster ARO ──────────────────────────────────────────────────────────────
resource "azurerm_redhat_openshift_cluster" "aro" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aro.location
  resource_group_name = azurerm_resource_group.aro.name
  tags                = var.tags

  depends_on = [
    azurerm_role_assignment.aro_contributor,
    azurerm_role_assignment.aro_rp_network,
    azurerm_role_assignment.sp_network,
    azurerm_resource_provider_registration.aro,
  ]

  cluster_profile {
    domain      = var.domain
    version     = "4.13.40"
    pull_secret = var.pull_secret
  }

  network_profile {
    pod_cidr     = var.pod_cidr
    service_cidr = var.service_cidr
  }

  main_profile {
    vm_size   = var.master_vm_size
    subnet_id = azurerm_subnet.master.id
  }

  worker_profile {
    vm_size      = var.worker_vm_size
    disk_size_gb = 128
    node_count   = var.worker_count
    subnet_id    = azurerm_subnet.worker.id
  }

  api_server_profile {
    visibility = "Public"
  }

  ingress_profile {
    visibility = "Public"
  }

  service_principal {
    client_id     = azuread_application.aro.client_id
    client_secret = azuread_application_password.aro.value
  }
}
