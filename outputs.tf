output "associations" {
  description = "The subnet associations created for the Application Gateway for Containers."
  value       = azapi_resource.associations
}

output "frontends" {
  description = "The frontends created for the Application Gateway for Containers."
  value       = azapi_resource.frontends
}

output "location" {
  description = "The location of the Application Gateway for Containers."
  value       = azapi_resource.traffic_controller.location
}

output "name" {
  description = "The name of the Application Gateway for Containers."
  value       = azapi_resource.traffic_controller.name
}

output "primary_configuration_endpoint" {
  description = "The primary configuration endpoint of the Application Gateway for Containers."
  value       = try(azapi_resource.traffic_controller.output.properties.configurationEndpoints[0], null)
}

output "resource" {
  description = "The full Application Gateway for Containers resource object."
  value       = azapi_resource.traffic_controller
}

output "resource_id" {
  description = "The ID of the Application Gateway for Containers (Traffic Controller)."
  value       = azapi_resource.traffic_controller.id
}

output "security_policies" {
  description = "The security policies created for the Application Gateway for Containers."
  value       = azapi_resource.security_policies
}
