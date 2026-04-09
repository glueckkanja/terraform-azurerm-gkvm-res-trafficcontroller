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
  location = local.supported_regions[random_integer.region_index.result]
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
  location = local.location
  name     = module.naming.resource_group.name_unique
  type     = "Microsoft.Resources/resourceGroups@2024-11-01"
}

# Virtual network with a delegated subnet for the traffic controller
resource "azapi_resource" "vnet" {
  location  = local.location
  name      = module.naming.virtual_network.name_unique
  parent_id = azapi_resource.rg.id
  type      = "Microsoft.Network/virtualNetworks@2024-05-01"
  body = {
    properties = {
      addressSpace = {
        addressPrefixes = ["10.0.0.0/16"]
      }
    }
  }
}

resource "azapi_resource" "subnet" {
  name      = "alb-subnet"
  parent_id = azapi_resource.vnet.id
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
  body = {
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "alb-delegation"
          properties = {
            serviceName = "Microsoft.ServiceNetworking/trafficControllers"
          }
        }
      ]
    }
  }
  response_export_values = ["*"]
}

# WAF policy for Application Gateway for Containers
resource "azapi_resource" "waf_policy" {
  location  = local.location
  name      = "${module.naming.application_gateway.name_unique}-waf-policy"
  parent_id = azapi_resource.rg.id
  type      = "Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2024-05-01"
  body = {
    properties = {
      managedRules = {
        managedRuleSets = [
          {
            ruleSetType    = "Microsoft_DefaultRuleSet"
            ruleSetVersion = "2.1"
          }
        ]
      }
      policySettings = {
        mode                        = "Prevention"
        state                       = "Enabled"
        requestBodyCheck            = true
        maxRequestBodySizeInKb      = 128
        fileUploadLimitInMb         = 100
        requestBodyEnforcement      = true
        fileUploadEnforcement       = true
        requestBodyInspectLimitInKB = 128
      }
    }
  }
  response_export_values = ["*"]
}

module "traffic_controller" {
  source = "../.."

  location  = local.location
  name      = module.naming.application_gateway.name_unique
  parent_id = azapi_resource.rg.id
  associations = {
    subnet1 = {
      name      = "assoc-subnet1"
      subnet_id = azapi_resource.subnet.id
    }
  }
  enable_telemetry = var.enable_telemetry
  frontends = {
    primary = {
      name = "frontend-primary"
    }
  }
  security_policies = {
    waf = {
      name        = "waf-policy"
      policy_type = "waf"
      waf_policy = {
        id = azapi_resource.waf_policy.id
      }
    }
  }
  tags = {
    environment = "example"
    scenario    = "waf"
  }
}
