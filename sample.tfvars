# Databricks Workspace
databricks_workspace_resource_id = "/subscriptions/378a2a19-d171-4f1d-8668-07b9890667eb/resourceGroups/devdb-rg/providers/Microsoft.Databricks/workspaces/devdb-workspace"

# Azure Infrastructure
############################################

resource_group_name = "rg-data-platform-prod"
location            = "eastus"

storage_account_name = "stucprod01"
container_name       = "uc-metastore"

tags = {
  environment = "prod"
  owner       = "data-platform"
  costcenter  = "analytics"
}

############################################
# Unity Catalog
############################################

metastore_name  = "uc-metastore-prod"
metastore_owner = "aad-databricks-admins"

# ⚠️ Leave false unless you REALLY want to destroy UC
force_destroy_metastore = false

############################################
# Security & Access
############################################

uc_admin_group_name       = "aad-databricks-admins"
access_connector_name     = "dbx-uc-access-prod"
storage_credential_name   = "uc-storage-credential-prod"
external_data_admin_group = "aad-data-engineers"

############################################
# Catalogs, Schemas & Grants
############################################

catalogs = {
  sandbox = {
    comment = "Sandbox catalog for experimentation"
    properties = {
      purpose = "POC"
      domain  = "sandbox"
    }

    grants = [
      {
        principal  = "aad-data-scientists"
        privileges = ["USE_CATALOG", "CREATE"]
      },
      {
        principal  = "aad-data-engineers"
        privileges = ["USE_CATALOG"]
      }
    ]

    schemas = {
      things = {
        comment = "Example schema managed by Terraform"
        properties = {
          kind = "various"
        }

        grants = [
          {
            principal  = "aad-data-engineers"
            privileges = ["USE_SCHEMA"]
          }
        ]
      }
    }
  }

  bronze = {
    comment = "Bronze raw data layer"
    properties = {
      domain = "ingestion"
      layer  = "bronze"
    }

    grants = [
      {
        principal  = "aad-data-engineers"
        privileges = ["USE_CATALOG", "CREATE"]
      }
    ]

    schemas = {
      raw = {
        comment    = "Raw ingested data"
        properties = {}

        grants = [
          {
            principal  = "aad-data-engineers"
            privileges = ["USE_SCHEMA", "CREATE_TABLE"]
          }
        ]
      }
    }
  }
}
