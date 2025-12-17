# --------------------------------------------------
# Core Key Vault configuration
# --------------------------------------------------

name                = "kv-prod-dbx-001"
location            = "eastus"
resource_group_name = "devdb-rg"

sku_name = "standard"

# --------------------------------------------------
# Security & lifecycle settings
# --------------------------------------------------

enabled_for_disk_encryption     = false
enabled_for_deployment          = false
enabled_for_template_deployment = false

soft_delete_retention_days = 90
purge_protection_enabled   = true

public_network_access_enabled = false
rbac_authorization_enabled    = true

# --------------------------------------------------
# Network ACLs (Private / Enterprise setup)
# --------------------------------------------------

network_acls = {
  bypass         = "AzureServices"
  default_action = "Deny"

  ip_rules = []

  virtual_network_subnet_ids = [
    "/subscriptions/378a2a19-d171-4f1d-8668-07b9890667eb/resourceGroups/devdb-rg/providers/Microsoft.Network/virtualNetworks/devdb-rg-vnet/subnets/devdb-private-snet"
  ]
}

# --------------------------------------------------
# Access Policies (LEGACY – only used if RBAC is false)
# MUST be empty when rbac_authorization_enabled = true
# --------------------------------------------------

access_policies = []

# --------------------------------------------------
# Databricks Secret Scope
# --------------------------------------------------

databricks_secret_scope_name = "kv-prod"

backend_type = "AZURE_KEYVAULT"

# --------------------------------------------------
# Tags (Enterprise standard)
# --------------------------------------------------

tags = {
  environment = "prod"
  platform    = "databricks"
  owner       = "data-platform"
  costcenter  = "fin-1234"
  managed_by  = "terraform"
}
