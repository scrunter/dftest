

resource "azurerm_resource_group" "tf_rg_datafactory" {
  name     = module.naming.resource_group.name
  location = module.region.location
}

resource "azurerm_user_assigned_identity" "tf_datafactory_uami" {
  location            = azurerm_resource_group.tf_rg_datafactory.location
  name                = "${module.naming.data_factory.name}-uami"
  resource_group_name = azurerm_resource_group.tf_rg_datafactory.name
}

resource "azurerm_role_assignment" "tf_datafactory_kv_df_umi_rbac" {
  scope                = azurerm_key_vault.tf_datafactory_kv.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.tf_datafactory_uami.principal_id
}


resource "azurerm_data_factory" "tf_datafactory" {
  depends_on = [ azurerm_role_assignment.tf_datafactory_kv_df_umi_rbac ]
  name                = module.naming.data_factory.name
  location            = azurerm_resource_group.tf_rg_datafactory.location
  resource_group_name = azurerm_resource_group.tf_rg_datafactory.name
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids  = [azurerm_user_assigned_identity.tf_datafactory_uami.id]
  }
  # Note, I've made this block conditional, on the basis you are only meant to attach your dev to git
  dynamic "vsts_configuration" {
    # If the environment is not dev, supply empty block, if dev, provide ado setup
    for_each = var.environment != "d" ? {} : { vsts_disabled = true }
    content {
        account_name = var.account_name
        branch_name = var.branch_name
        project_name = var.project_name
        repository_name = var.repository_name
        root_folder = var.root_folder
        tenant_id = data.azurerm_client_config.current.tenant_id
    }
  }
  managed_virtual_network_enabled = true
  public_network_enabled = false
  customer_managed_key_id = azurerm_key_vault_key.tf_datafactory_cmkkey.id
  customer_managed_key_identity_id = azurerm_user_assigned_identity.tf_datafactory_uami.id
}

resource "azurerm_private_endpoint" "tf_datafactory" {
  name                = "${azurerm_data_factory.tf_datafactory.name}-pep"
  location            = azurerm_resource_group.tf_rg_datafactory.location
  resource_group_name = azurerm_resource_group.tf_rg_datafactory.name
  subnet_id           = data.azurerm_subnet.tf_plink_subnet.id

  private_service_connection {
    name                           = "${azurerm_data_factory.tf_datafactory.name}-pep"
    private_connection_resource_id = azurerm_data_factory.tf_datafactory.id
    subresource_names              = ["datafactory"]
    is_manual_connection           = false
  }

  /* Enable this when your principal has access to the centralised DNS zones
  private_dns_zone_group {
    name                 = "${module.region.location_short}.privatelink.datafactory.azure.net"
    private_dns_zone_ids = var.pdnszoneid # This will need a lookup in reality.
  } 
  */ 
}