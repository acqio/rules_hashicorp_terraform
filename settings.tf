terraform {
  required_version = ">= 0.14.0"
  required_providers {
    azurerm = {
      version = ">=2.3"
    }
    template = {
      version = ">=2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "=2.0"
    }
  }
}
