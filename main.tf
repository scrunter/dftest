data "azurerm_client_config" "current" {}

module region {
  source = "claranet/regions/azurerm"
  version = "6.1.0"
  azure_region = var.location
}

module naming {
  source  = "Azure/naming/azurerm"
  version = "0.2.0"
  prefix = ["fbd", var.environment, module.region.location_short, "app", var.app]
  suffix = []
}

data "azurerm_subnet" "tf_plink_subnet" {
  name = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name = var.vnet_rg
}