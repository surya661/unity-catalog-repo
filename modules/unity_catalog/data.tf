data "azurerm_resource_group" "this" {
  name = local.resource_group
}

data "azurerm_client_config" "current" {
}

data "azurerm_databricks_workspace" "this" {
  name                = local.databricks_workspace_name
  resource_group_name = local.resource_group
}
/*
data "databricks_group" "dev" {
    provider = databricks.workspace
     display_name = var.group_name
  
}
data "databricks_user" "dev" {
    provider = databricks.workspace
    for_each = data.databricks_group.uat.members
    user_id = each.key
  
}
*/