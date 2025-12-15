module "unity_catalog" {
  source                 = "./modules/unity_catalog"
  databricks_workspace_resource_id = var.databricks_workspace_resource_id
  resource_group_name    = var.resource_group_name
  location               = var.location
  container_name         = var.container_name
  metastore_name         = var.metastore_name
  storage_account_name   = var.storage_account_name
  metastore_owner = var.metastore_owner
  tags = var.tags
  force_destroy_metastore = var.force_destroy_metastore
  catalogs = var.catalogs
  uc_admin_group_name = var.uc_admin_group_name
  access_connector_name = var.access_connector_name
  storage_credential_name = var.storage_credential_name
  external_data_admin_group = var.external_data_admin_group

}