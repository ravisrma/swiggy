variable "environment" {
  description = "The environment for the infrastructure"
  type        = string
  default     = "stage"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}



variable "web_service_cpu" {
  description = "The CPU units for the web service"
  type        = number
  default     = 256
}

variable "web_service_memory" {
  description = "The memory for the web service"
  type        = number
  default     = 512
}

variable "web_service_port" {
  description = "The port for the web service"
  type        = number
  default     = 80
}

variable "region" {
  description = "The region for the infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "alb_public_access" {
  description = "Whether the ALB should be publicly accessible"
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "The ARN for the ACM certificate"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}



variable "create_env_bucket" {
  description = "Whether to create an environment bucket"
  type        = bool
  default     = false
}

variable "web_service_environment" {
  description = "Environment variables for the web service"
  type        = list(map(string))
  default     = null
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot"
  type        = bool
  default     = true
}