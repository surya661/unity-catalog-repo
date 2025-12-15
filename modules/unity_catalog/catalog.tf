# Creates top-level Unity Catalog catalogs
# Catalogs represent logical data domains
resource "databricks_catalog" "this" {
  provider = databricks.workspace
  for_each = var.catalogs

  name    = each.key
  comment = each.value.comment
  properties = each.value.properties

  depends_on = [
    databricks_metastore_assignment.this
  ]
}
# Catalog-Level Grants
resource "databricks_grants" "catalogs" {
  provider = databricks.workspace
  for_each = var.catalogs

  catalog = databricks_catalog.this[each.key].name

  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
resource "databricks_schema" "this" {
  provider = databricks.workspace

  for_each = {
    for s in local.schemas :
    s.key => s
  }

  catalog_name = each.value.catalog_name
  name         = each.value.schema_name
  comment      = each.value.schema.comment
  properties   = each.value.schema.properties
}

# Schema-Level Grants
resource "databricks_grants" "schemas" {
  provider = databricks.workspace

  for_each = {
    for s in local.schemas :
    s.key => s
    if length(s.schema.grants) > 0
  }

  schema = databricks_schema.this[each.key].id

  dynamic "grant" {
    for_each = each.value.schema.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

