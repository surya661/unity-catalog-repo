resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = local.tenant_id
  sku_name            = var.sku_name


  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment


  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled


  public_network_access_enabled = var.public_network_access_enabled
  rbac_authorization_enabled    = var.rbac_authorization_enabled

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [var.network_acls]
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }

  }
  lifecycle {
    precondition {
      condition     = !(var.rbac_authorization_enabled && length(var.access_policies) > 0)
      error_message = "access_policies cannot be set when rbac_authorization_enabled is true."
    }
  }

  tags = var.tags
}
resource "azurerm_key_vault_access_policy" "this" {
  for_each = {
    for idx, policy in var.access_policies :
    idx => policy
  }

  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
  storage_permissions     = each.value.storage_permissions

  lifecycle {
    precondition {
      condition = (
        (each.value.object_id != null && each.value.application_id == null) ||
        (each.value.object_id == null && each.value.application_id != null)
      )
      error_message = "Exactly one of object_id or application_id must be specified for a Key Vault access policy."
    }
  }

}

resource "azurerm_role_assignment" "databricks_kv" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}

#databricks resource
resource "databricks_secret_scope" "keyvault" {
  name         = var.databricks_secret_scope_name
  backend_type = var.backend_type
  keyvault_metadata {
    resource_id = azurerm_key_vault.this.id
    dns_name    = azurerm_key_vault.this.vault_uri
  }
}