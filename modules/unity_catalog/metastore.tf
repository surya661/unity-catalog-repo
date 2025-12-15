#Unity Catalog Metastore - One per region
# Central governance object for Databricks
resource "databricks_metastore" "this" {
  provider = databricks.workspace
  name     = var.metastore_name
  region   = var.location
  # Owner should be an Azure AD group
  owner = var.metastore_owner
  # Root storage for all UC-managed data
  storage_root = format(
    "abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.metastore.name,
    azurerm_storage_account.uc.name
  )
  # Destructive operation – must be explicitly enabled
  force_destroy = var.force_destroy_metastore
  depends_on = [
    azurerm_storage_container.metastore
  ]

}
# Explicitly assigns the metastore to a workspace
# Without this, the workspace cannot see Unity Catalog
resource "databricks_metastore_assignment" "this" {
  provider     = databricks.workspace
  metastore_id = databricks_metastore.this.id
  workspace_id = local.databricks_workspace_id

}