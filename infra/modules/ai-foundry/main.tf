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

# AI Foundry account (Cognitive Services - AIServices kind)
resource "azurerm_cognitive_account" "main" {
  name                = "ai-${var.environment_name}-${var.resource_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "AIServices"
  sku_name            = "S0"

  custom_subdomain_name = "ai-${var.environment_name}-${var.resource_suffix}"

  tags = var.tags
}

# GPT-4 model deployment
resource "azurerm_cognitive_deployment" "gpt4" {
  name                 = "gpt-4o"
  cognitive_account_id = azurerm_cognitive_account.main.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o"
    version = "2024-08-06"
  }

  sku {
    name     = "GlobalStandard"
    capacity = 10
  }
}

# GPT-4o-mini model deployment
resource "azurerm_cognitive_deployment" "phi" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_cognitive_account.main.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }

  sku {
    name     = "GlobalStandard"
    capacity = 1
  }

  depends_on = [azurerm_cognitive_deployment.gpt4]
}

output "endpoint" {
  value = azurerm_cognitive_account.main.endpoint
}

output "id" {
  value = azurerm_cognitive_account.main.id
}
