variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "resource_suffix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "container_registry_login_server" {
  type = string
}

variable "container_registry_id" {
  type = string
}

variable "application_insights_connection_string" {
  type = string
}

# App Service Plan (Linux, F1 for dev)
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.environment_name}-${var.resource_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
  tags                = var.tags
}

# App Service (Linux, Docker container from ACR)
resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.environment_name}-${var.resource_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  tags = merge(var.tags, {
    "azd-service-name" = "web"
  })

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                               = false
    ftps_state                              = "Disabled"
    minimum_tls_version                     = "1.2"
    container_registry_use_managed_identity = true

    application_stack {
      docker_registry_url = "https://${var.container_registry_login_server}"
      docker_image_name   = "zava-storefront/web:latest"
    }
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.application_insights_connection_string
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"   = "false"
  }

  https_only = true

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image_name,
    ]
  }
}

# RBAC: App Service → ACR (AcrPull role)
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.container_registry_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.main.identity[0].principal_id
}

output "default_hostname" {
  value = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "principal_id" {
  value = azurerm_linux_web_app.main.identity[0].principal_id
}
