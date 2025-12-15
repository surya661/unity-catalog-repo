# ADLS Gen2 is mandatory for Unity Catalog metastore storage
# This storage holds metadata and managed table data
resource "azurerm_storage_account" "uc" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # Required for Unity Catalog
  is_hns_enabled           = true

  identity {
    type = "SystemAssigned"
  }
  tags = data.azurerm_resource_group.this.tags
}
# Container used as the UC metastore root
resource "azurerm_storage_container" "metastore" {
  name = var.container_name
  storage_account_id    = azurerm_storage_account.uc.id
  container_access_type = "private"

}
/*
resource "databricks_external_location" "this" {
    name = var.external_location_name
    url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_container.uc.name,
  azurerm_storage_account.uc.name)
  credential_name = databricks_storage_credential.ext.id
  comment = "Managed by Terraform"
  depends_on = [ databricks_metastore_assignment.this ]
  
}
resource "databricks_grants" "external_location" {
    external_location = databricks_external_location.this.id
    grant {
      principal = var.external_location_admin_group
      privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES"]
    }
  
}
*/