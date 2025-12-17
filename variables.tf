variable "name" {
  description = "Explicit Key Vault name. Ignored when naming is provided."
  type        = string
  default     = null
}


variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "tenant_id" {
  type    = string
  default = null
}
variable "sku_name" {
  type    = string
  default = "standard"
}
variable "rbac_authorization_enabled" {
  description = "Enable Azure RBAC authorization for Key Vault. Recommended and default for enterprise usage."
  type        = bool
  default     = true
}
variable "enabled_for_disk_encryption" {
  type    = bool
  default = false
}
variable "enabled_for_deployment" {
  type    = bool
  default = false
}
variable "enabled_for_template_deployment" {
  type    = bool
  default = false
}
variable "soft_delete_retention_days" {
  type    = number
  default = 90
}
variable "purge_protection_enabled" {
  type    = bool
  default = true
}
variable "public_network_access_enabled" {
  type    = bool
  default = false
}
variable "network_acls" {
  description = <<EOT
Optional network access control configuration for the Key Vault.

When set, controls public and private network access including:
- Default action (Allow/Deny)
- Azure service bypass
- IP rules
- Virtual network subnet rules
EOT

  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })

  default = null
  validation {
    condition     = var.network_acls == null || contains(["Allow", "Deny"], var.network_acls.default_action)
    error_message = "network_acls.default_action must be either Allow or Deny."
  }

}

variable "tags" {
  type    = map(string)
  default = {}
}
#access policy
variable "access_policies" {
  description = <<EOT
Optional list of Azure Key Vault access policies.

This should only be used when RBAC authorization is disabled.
Access policies are considered legacy; Azure RBAC is recommended.
EOT

  type = list(object({
    tenant_id = string
    object_id = string

    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))

  default = []
}

#databricks scope
variable "databricks_secret_scope_name" {
  type = string

}
variable "backend_type" {
  type = string

}
#databricks
variable "databricks_workspace_url" {
  type = string

}