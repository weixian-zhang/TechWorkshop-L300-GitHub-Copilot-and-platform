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

# Azure Container Registry (Basic SKU, admin disabled, RBAC-based access)
resource "azurerm_container_registry" "main" {
  name                = "cr${var.environment_name}${var.resource_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}

output "login_server" {
  value = azurerm_container_registry.main.login_server
}

output "id" {
  value = azurerm_container_registry.main.id
}

output "name" {
  value = azurerm_container_registry.main.name
}
