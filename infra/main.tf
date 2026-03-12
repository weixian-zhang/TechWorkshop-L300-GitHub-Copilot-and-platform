locals {
  tags = {
    "azd-env-name" = var.environment_name
  }
  resource_suffix = substr(sha256("${var.environment_name}-${var.location}"), 0, 6)
}

resource "azurerm_resource_group" "main" {
  name     = "lab-l300-copilot"
  location = var.location
  tags     = local.tags
}

module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment_name    = var.environment_name
  resource_suffix     = local.resource_suffix
  tags                = local.tags
}

module "container_registry" {
  source              = "./modules/container-registry"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment_name    = var.environment_name
  resource_suffix     = local.resource_suffix
  tags                = local.tags
}

module "app_service" {
  source              = "./modules/app-service"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment_name    = var.environment_name
  resource_suffix     = local.resource_suffix
  tags                = local.tags

  container_registry_login_server = module.container_registry.login_server
  container_registry_id           = module.container_registry.id

  application_insights_connection_string = module.monitoring.application_insights_connection_string
}

module "ai_foundry" {
  source              = "./modules/ai-foundry"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment_name    = var.environment_name
  resource_suffix     = local.resource_suffix
  tags                = local.tags
}
