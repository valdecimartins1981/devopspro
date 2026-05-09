resource "azurerm_public_ip" "appgw" {
  name                = "pip-${var.appgw_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

locals {
  frontend_ip_config_name  = "appgw-frontend-ip"
  frontend_port_name_http  = "appgw-port-80"
  frontend_port_name_https = "appgw-port-443"
  backend_pool_name        = "appgw-backend-pool"
  backend_http_setting     = "appgw-backend-http-settings"
  listener_http_name       = "appgw-listener-http"
  listener_https_name      = "appgw-listener-https"
  routing_rule_name        = "appgw-routing-rule"
  redirect_config_name     = "appgw-redirect-config"
}

resource "azurerm_application_gateway" "this" {
  name                = var.appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = local.frontend_port_name_http
    port = 80
  }

  frontend_port {
    name = local.frontend_port_name_https
    port = 443
  }

  backend_address_pool {
    name = local.backend_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_setting
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60

    probe_name = "appgw-health-probe"
  }

  http_listener {
    name                           = local.listener_http_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_name_http
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_http_name
    backend_address_pool_name  = local.backend_pool_name
    backend_http_settings_name = local.backend_http_setting
    priority                   = 100
  }

  probe {
    name                = "appgw-health-probe"
    host                = "127.0.0.1"
    interval            = 30
    path                = "/health"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
  }

  waf_configuration {
    enabled          = var.enable_waf
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}
