terraform {
  required_version = "~> 1.11"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.5"
    }
  }
}

provider "azapi" {}

## Section to provide a random Azure region for the resource group
locals {
  supported_regions = [
    "australiaeast", "centralus", "eastasia", "eastus", "eastus2",
    "northcentralus", "northeurope", "southcentralus", "southeastasia",
    "uksouth", "westus", "westeurope", "uaenorth", "westus3",
    "brazilsouth", "westus2", "japaneast", "switzerlandnorth",
    "swedencentral", "norwayeast", "koreacentral", "francecentral",
    "canadacentral", "germanywestcentral", "centralindia",
  ]
}

resource "random_integer" "region_index" {
  max = length(local.supported_regions) - 1
  min = 0
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

resource "azapi_resource" "rg" {
  location = local.supported_regions[random_integer.region_index.result]
  name     = module.naming.resource_group.name_unique
  type     = "Microsoft.Resources/resourceGroups@2024-11-01"
}

module "traffic_controller" {
  source = "../.."

  location            = azapi_resource.rg.location
  name                = module.naming.application_gateway.name_unique
  resource_group_name = azapi_resource.rg.name
  enable_telemetry    = var.enable_telemetry
}
