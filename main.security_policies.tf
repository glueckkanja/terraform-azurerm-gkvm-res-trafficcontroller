resource "azapi_resource" "security_policies" {
  for_each = var.security_policies

  location  = var.location
  name      = each.value.name
  parent_id = azapi_resource.traffic_controller.id
  type      = "Microsoft.ServiceNetworking/trafficControllers/securityPolicies@${var.api_version}"
  body = {
    properties = {
      wafPolicy = each.value.waf_policy != null ? {
        id = each.value.waf_policy.id
      } : null
    }
  }
  create_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers              = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  response_export_values    = ["*"]
  schema_validation_enabled = false
  tags                      = each.value.tags
  update_headers            = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
}
