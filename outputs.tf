output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.swiggy-app-infra.alb_dns_name
}

output "web_ecr" {
  description = "The ECR URL for the web"
  value       = module.swiggy-app-infra.web_ecr
}
