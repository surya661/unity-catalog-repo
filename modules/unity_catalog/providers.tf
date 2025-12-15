terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}
# Databricks provider authenticated via Azure AD
# Uses workspace resource ID so no PAT tokens are required
provider "databricks" {
  alias                       = "workspace"
  azure_workspace_resource_id = local.databricks_workspace_id
  azure_use_msi               = true
}