variable "environment_name" {
  type        = string
  description = "Environment name from azd (e.g. dev)"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "westus3"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}
