resource "azapi_resource" "traffic_controller" {
  location  = var.location
  name      = var.name
  parent_id = var.parent_id
  type      = "Microsoft.ServiceNetworking/trafficControllers@${var.api_version}"
  body = {
    properties = var.security_policy_configurations != null ? {
      securityPolicyConfigurations = {
        ipAccessRulesSecurityPolicy = var.security_policy_configurations.ip_access_rules_security_policy_id != null ? {
          id = var.security_policy_configurations.ip_access_rules_security_policy_id
        } : null
        wafSecurityPolicy = var.security_policy_configurations.waf_security_policy_id != null ? {
          id = var.security_policy_configurations.waf_security_policy_id
        } : null
      }
    } : {}
  }
  create_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers              = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  response_export_values    = ["*"]
  schema_validation_enabled = false
  tags                      = var.tags
  update_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}
