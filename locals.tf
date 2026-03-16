data "azapi_client_config" "current" {}

data "azapi_resource" "rg" {
  name = var.resource_group_name
  type = "Microsoft.Resources/resourceGroups@2024-11-01"
}

locals {
  resource_group_id = data.azapi_resource.rg.id
}
