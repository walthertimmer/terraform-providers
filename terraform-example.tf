# Example Terraform configuration for using GitHub-hosted providers

terraform {
  required_providers {
    azurerm = {
      source  = "github.com/walthertimmer/terraform-providers/azurerm"
      version = "3.75.0"
    }
    time = {
      source  = "github.com/walthertimmer/terraform-providers/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
  # Add any necessary provider configuration
}

# Example resource that uses both providers
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [azurerm_resource_group.example]
  create_duration = "30s"
}
