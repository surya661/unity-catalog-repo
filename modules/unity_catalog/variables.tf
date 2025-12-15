# Databricks Workspace
variable "databricks_workspace_resource_id" {
  description = "Azure resource ID of the existing Databricks workspace"
  type        = string

  validation {
    condition = can(
      regex(
        "^/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Databricks/workspaces/.+$",
        var.databricks_workspace_resource_id
      )
    )
    error_message = "databricks_workspace_resource_id must be a valid Azure Databricks workspace resource ID."
  }
}

# Azure Infrastructure
variable "resource_group_name" {
  description = "Resource group containing UC storage resources"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name cannot be empty."
  }
}

variable "location" {
  description = "Azure region (must match Databricks workspace region)"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "location must be provided."
  }
}
variable "storage_account_name" {
  description = "ADLS Gen2 storage account name for Unity Catalog"
  type        = string

  validation {
    condition = can(
      regex("^[a-z0-9]{3,24}$", var.storage_account_name)
    )
    error_message = "storage_account_name must be 3–24 lowercase alphanumeric characters."
  }
}

variable "container_name" {
  description = "Storage container used as Unity Catalog metastore root"
  type        = string

  validation {
    condition = can(
      regex("^[a-z0-9-]{3,63}$", var.container_name)
    )
    error_message = "container_name must be 3–63 characters and contain only lowercase letters, numbers, and hyphens."
  }
}

# Unity Catalog
variable "metastore_name" {
  description = "Unity Catalog metastore name (one per region)"
  type        = string

  validation {
    condition     = length(var.metastore_name) > 0
    error_message = "metastore_name cannot be empty."
  }
}

variable "metastore_owner" {
  description = "Principal (AAD group or user) that owns the metastore"
  type        = string

  validation {
    condition     = length(var.metastore_owner) > 0
    error_message = "metastore_owner must be provided."
  }
}
variable "force_destroy_metastore" {
  description = "Allow Terraform to destroy the Unity Catalog metastore (DANGEROUS)"
  type        = bool
  default     = false
}
#catalog
variable "catalogs" {
  description = "Unity Catalog catalogs and schemas"

  type = map(object({
    comment    = string
    properties = map(string)
    grants = list(object({
      principal  = string
      privileges = list(string)
    }))
    schemas = map(object({
      comment    = string
      properties = map(string)
      grants = list(object({
        principal  = string
        privileges = list(string)
      }))
    }))
  }))

  validation {
    condition = alltrue([
      for c in var.catalogs :
      length(c.grants) > 0 &&
      alltrue([
        for g in c.grants : length(g.privileges) > 0
      ])
    ])
    error_message = "Each catalog must define at least one grant with at least one privilege."
  }
}
# Security & Access
variable "uc_admin_group_name" {
  description = "Azure AD group name for Unity Catalog administrators"
  type        = string

  validation {
    condition     = length(var.uc_admin_group_name) > 0
    error_message = "uc_admin_group_name must be provided."
  }
}

variable "access_connector_name" {
  description = "Name of the Databricks access connector"
  type        = string

  validation {
    condition     = length(var.access_connector_name) > 0
    error_message = "access_connector_name must be provided."
  }
}

variable "storage_credential_name" {
  description = "Unity Catalog storage credential name"
  type        = string

  validation {
    condition     = length(var.storage_credential_name) > 0
    error_message = "storage_credential_name must be provided."
  }
}

variable "external_data_admin_group" {
  description = "AAD group allowed to create external tables"
  type        = string

  validation {
    condition     = length(var.external_data_admin_group) > 0
    error_message = "external_data_admin_group must be provided."
  }
}

# Optional
variable "tags" {
  description = "Tags applied to Azure resources"
  type        = map(string)
  default     = {}
}
#external storage
/*
variable "external_location_name" {
  description = "Name of the Unity Catalog external location"
  type        = string
}

variable "external_container_name" {
  description = "ADLS container used for external data"
  type        = string
}

variable "external_location_admin_group" {
  description = "AAD group allowed to manage external data"
  type        = string
}
*/