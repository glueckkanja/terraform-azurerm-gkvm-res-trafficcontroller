variable "location" {
  type        = string
  description = <<DESCRIPTION
The Azure region where the Application Gateway for Containers (Traffic Controller) will be deployed.
DESCRIPTION
  nullable    = false
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
The name of the Application Gateway for Containers (Traffic Controller).
DESCRIPTION
  nullable    = false

  validation {
    condition     = can(regex("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$", var.name))
    error_message = "Name must match the pattern ^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$."
  }
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
The name of the resource group in which to create the Application Gateway for Containers.
DESCRIPTION
  nullable    = false
}

variable "api_version" {
  type        = string
  default     = "2025-01-01"
  description = <<DESCRIPTION
The API version to use for the Microsoft.ServiceNetworking resource provider.
DESCRIPTION
  nullable    = false
}

variable "associations" {
  type = map(object({
    name      = string
    subnet_id = string
    tags      = optional(map(string), null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of subnet associations for the Application Gateway for Containers.

- `name` - (Required) The name of the subnet association.
- `subnet_id` - (Required) The ID of the subnet to associate. The subnet must be delegated to `Microsoft.ServiceNetworking/trafficControllers`.
- `tags` - (Optional) A mapping of tags to assign to the association resource.
DESCRIPTION
  nullable    = false
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "frontends" {
  type = map(object({
    name = string
    tags = optional(map(string), null)
    security_policy_configurations = optional(object({
      ip_access_rules_security_policy_id = optional(string)
      waf_security_policy_id             = optional(string)
    }))
  }))
  default     = {}
  description = <<DESCRIPTION
A map of frontends for the Application Gateway for Containers.

- `name` - (Required) The name of the frontend.
- `tags` - (Optional) A mapping of tags to assign to the frontend resource.
- `security_policy_configurations` - (Optional) Security policy configuration for this frontend.
  - `ip_access_rules_security_policy_id` - (Optional) Resource ID of an IP Access Rules security policy.
  - `waf_security_policy_id` - (Optional) Resource ID of a WAF security policy.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `"CanNotDelete"` and `"ReadOnly"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "Lock kind must be either \"CanNotDelete\" or \"ReadOnly\"."
  }
}

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = null
  description = <<DESCRIPTION
Managed identity configuration. Currently used by the AVM interfaces module for role assignment scope resolution.

- `system_assigned` - (Optional) Whether to enable system-assigned managed identity. Defaults to `false`.
- `user_assigned_resource_ids` - (Optional) A set of user-assigned managed identity resource IDs.
DESCRIPTION
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on the Application Gateway for Containers. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - (Optional) The description of the role assignment.
- `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - (Optional) The condition which will be used to scope the role assignment.
- `condition_version` - (Optional) The version of the condition syntax. Leave as `null` if you are not using a condition, if you are then valid values are '2.0'.
- `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity.
- `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "security_policies" {
  type = map(object({
    name        = string
    policy_type = string
    tags        = optional(map(string), null)
    waf_policy = optional(object({
      id = string
    }))
  }))
  default     = {}
  description = <<DESCRIPTION
A map of security policies to create as sub-resources of the Application Gateway for Containers.

- `name` - (Required) The name of the security policy.
- `policy_type` - (Required) The type of security policy. Possible values are `"waf"`.
- `tags` - (Optional) A mapping of tags to assign to the security policy resource.
- `waf_policy` - (Optional) WAF policy configuration. Required when `policy_type` is `"waf"`.
  - `id` - (Required) The resource ID of the WAF policy to associate.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for k, v in var.security_policies : contains(["waf"], v.policy_type)])
    error_message = "policy_type must be one of: \"waf\"."
  }
}

variable "security_policy_configurations" {
  type = object({
    ip_access_rules_security_policy_id = optional(string)
    waf_security_policy_id             = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Security policy configuration for the Traffic Controller.

- `ip_access_rules_security_policy_id` - (Optional) Resource ID of an IP Access Rules security policy to attach to the traffic controller.
- `waf_security_policy_id` - (Optional) Resource ID of a WAF security policy to attach to the traffic controller.
DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
A mapping of tags to assign to the Traffic Controller resource.
DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
  })
  default     = null
  description = <<DESCRIPTION
Timeouts for resource operations.

- `create` - (Optional) Timeout for creating the resource. Defaults to `30m`.
- `delete` - (Optional) Timeout for deleting the resource. Defaults to `30m`.
- `read` - (Optional) Timeout for reading the resource. Defaults to `5m`.
- `update` - (Optional) Timeout for updating the resource. Defaults to `30m`.
DESCRIPTION
}
