resource "azurerm_key_vault" "tf_datafactory_kv" {
  name                        = module.naming.key_vault.name_unique
  location                    = azurerm_resource_group.tf_rg_datafactory.location
  resource_group_name         = azurerm_resource_group.tf_rg_datafactory.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name = "standard"
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "tf_datafactory_kv_rbac" {
  scope                = azurerm_key_vault.tf_datafactory_kv.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_key" "tf_datafactory_cmkkey" {
  depends_on = [ azurerm_role_assignment.tf_datafactory_kv_rbac ]
  name         = "${module.naming.data_factory.name}-key"
  key_vault_id = azurerm_key_vault.tf_datafactory_kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}