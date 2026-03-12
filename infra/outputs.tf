output "AZURE_RESOURCE_GROUP" {
  value = azurerm_resource_group.main.name
}

output "AZURE_CONTAINER_REGISTRY_ENDPOINT" {
  value = module.container_registry.login_server
}

output "AZURE_CONTAINER_REGISTRY_NAME" {
  value = module.container_registry.name
}

output "AZURE_LOG_ANALYTICS_WORKSPACE_ID" {
  value = module.monitoring.log_analytics_workspace_id
}

output "WEB_URL" {
  value = module.app_service.default_hostname
}

output "AZURE_AI_FOUNDRY_ENDPOINT" {
  value = module.ai_foundry.endpoint
}
