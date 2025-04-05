module "swiggy-app-infra" {
  source                = "./swiggy-app-infra"
  project_name          = var.project_name
  environment           = var.environment
  region                = var.region
  web_service_cpu    = var.web_service_cpu
  web_service_memory = var.web_service_memory
  web_service_port   = var.web_service_port
  acm_certificate_arn   = var.acm_certificate_arn
}