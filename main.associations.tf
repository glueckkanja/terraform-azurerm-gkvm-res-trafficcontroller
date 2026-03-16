resource "azapi_resource" "associations" {
  for_each = var.associations

  location  = var.location
  name      = each.value.name
  parent_id = azapi_resource.traffic_controller.id
  type      = "Microsoft.ServiceNetworking/trafficControllers/associations@${var.api_version}"
  body = {
    properties = {
      associationType = "subnets"
      subnet = {
        id = each.value.subnet_id
      }
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
