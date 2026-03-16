output "associations" {
  description = "The subnet associations created for the Application Gateway for Containers."
  value       = module.traffic_controller.associations
}

output "frontends" {
  description = "The frontends created for the Application Gateway for Containers."
  value       = module.traffic_controller.frontends
}

output "name" {
  description = "The name of the Application Gateway for Containers."
  value       = module.traffic_controller.name
}

output "resource_id" {
  description = "The ID of the Application Gateway for Containers."
  value       = module.traffic_controller.resource_id
}
