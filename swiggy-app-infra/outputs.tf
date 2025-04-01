output "alb_dns_name" {
  value = module.alb.dns_name
}

output "web_ecr" {
  value = module.web_ecr.repository_url
}



output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_web_service_name" {
  value = module.web_ecs_service.name
}



output "ecs_web_task_definition_family" {
  value = module.web_ecs_service.task_definition_family
}

