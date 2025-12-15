locals {
  resource_regex            = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Databricks/workspaces/(.+)"
  subscription_id           = regex(local.resource_regex, var.databricks_workspace_resource_id)[0]
  resource_group            = regex(local.resource_regex, var.databricks_workspace_resource_id)[1]
  databricks_workspace_name = regex(local.resource_regex, var.databricks_workspace_resource_id)[2]
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  databricks_workspace_host = data.azurerm_databricks_workspace.this.workspace_url
  databricks_workspace_id   = data.azurerm_databricks_workspace.this.workspace_id
  prefix                    = replace(replace(lower(data.azurerm_resource_group.this.name), "rg", ""), "-", "")
}
locals {
  schemas = flatten([
    for catalog_name, catalog in var.catalogs : [
      for schema_name, schema in catalog.schemas : {
        key          = "${catalog_name}.${schema_name}"
        catalog_name = catalog_name
        schema_name  = schema_name
        schema       = schema
      }
    ]
  ])
}
