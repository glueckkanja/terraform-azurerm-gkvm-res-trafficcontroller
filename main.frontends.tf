resource "azapi_resource" "frontends" {
  for_each = var.frontends

  location  = var.location
  name      = each.value.name
  parent_id = azapi_resource.traffic_controller.id
  type      = "Microsoft.ServiceNetworking/trafficControllers/frontends@${var.api_version}"
  body = {
    properties = each.value.security_policy_configurations != null ? {
      securityPolicyConfigurations = {
        ipAccessRulesSecurityPolicy = each.value.security_policy_configurations.ip_access_rules_security_policy_id != null ? {
          id = each.value.security_policy_configurations.ip_access_rules_security_policy_id
        } : null
        wafSecurityPolicy = each.value.security_policy_configurations.waf_security_policy_id != null ? {
          id = each.value.security_policy_configurations.waf_security_policy_id
        } : null
      }
    } : {}
  }
  create_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers              = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  response_export_values    = ["*"]
  schema_validation_enabled = false
  tags                      = each.value.tags
  update_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
}
