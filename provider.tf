terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.56.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy                            = false
      purge_soft_deleted_certificates_on_destroy              = false
      purge_soft_deleted_keys_on_destroy                      = false
      purge_soft_deleted_secrets_on_destroy                   = false
      purge_soft_deleted_hardware_security_modules_on_destroy = false
    }
  }
  subscription_id = var.subscription_id
  ## You would enable these when using a service principal inside a pipeline for example
  #client_id       = var.client_id
  #client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
