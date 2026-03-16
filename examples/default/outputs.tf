output "name" {
  description = "The name of the Application Gateway for Containers."
  value       = module.traffic_controller.name
}

output "resource_id" {
  description = "The ID of the Application Gateway for Containers."
  value       = module.traffic_controller.resource_id
}
