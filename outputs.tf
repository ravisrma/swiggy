output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.web-app-infra.alb_dns_name
}

output "web_ecr" {
  description = "The ECR URL for the web"
  value       = module.web-app-infra.web_ecr
}
