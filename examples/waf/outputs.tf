output "name" {
  description = "The name of the Application Gateway for Containers."
  value       = module.traffic_controller.name
}

output "resource_id" {
  description = "The ID of the Application Gateway for Containers."
  value       = module.traffic_controller.resource_id
}

output "security_policies" {
  description = "The security policies created for the Application Gateway for Containers."
  value       = module.traffic_controller.security_policies
}
