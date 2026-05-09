resource "azurerm_api_management" "this" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "${var.sku_tier}_${var.sku_capacity}"
  tags                = var.tags

  virtual_network_type = "Internal"

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "apim" {
  name                = "pe-${var.apim_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.apim_name}"
    private_connection_resource_id = azurerm_api_management.this.id
    subresource_names              = ["Gateway"]
    is_manual_connection           = false
  }
}
