# The access connector provides a managed identity
# that Databricks uses to access external Azure storage
# for Unity Catalog external locations and tables.
resource "azurerm_databricks_access_connector" "this" {
    name = var.access_connector_name
    resource_group_name = data.azurerm_resource_group.this.name
    location = data.azurerm_resource_group.this.location
    identity {
      type = "SystemAssigned"
    }
    tags = var.tags
  
}
# Grants the Databricks managed identity permission
# to read/write data in ADLS Gen2.
resource "azurerm_role_assignment" "uc-storage" {
  scope                = azurerm_storage_account.uc.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id

}
# Unity Catalog Storage Credential
resource "databricks_storage_credential" "this" {
    provider = databricks.workspace
    name = var.storage_credential_name
    azure_managed_identity {
      access_connector_id = azurerm_databricks_access_connector.this.id
    }
    comment = "Managed by terraform"
    # UC metastore must be assigned before creating credentials
    depends_on = [ databricks_metastore_assignment.this ]
  
}
# Unity Catalog Grants on Storage Credential
resource "databricks_grants" "ext_creds" {
    provider = databricks.workspace
    storage_credential = databricks_storage_credential.this.id
    grant {
      principal =  var.external_data_admin_group
      privileges = ["CREATE_EXTERNAL_TABLE"]
    }
  
}
