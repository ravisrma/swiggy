module "s3_env_bucket" {
  count  = var.create_env_bucket ? 1 : 0
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "${local.prefix}-envs"
}
resource "aws_service_discovery_http_namespace" "ecs_service_namespace" {
  name = local.prefix
  tags = local.tags
}

module "s3_web_asset_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "${local.prefix}-web-assets"
}

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name                = "${local.prefix}-ecs-cluster"
  create_cloudwatch_log_group = true
  tags                        = local.tags
}


module "web_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                 = "${local.prefix}-web"
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.tags
}



module "web_ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name                   = "${local.prefix}-web"
  cluster_arn            = module.ecs_cluster.cluster_arn
  enable_execute_command = true

  cpu    = var.web_service_cpu
  memory = var.web_service_memory

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  container_definitions = {
    web = {
      cpu         = "${var.web_service_cpu}"
      memory      = "${var.web_service_memory}"
      image       = module.web_ecr.repository_url
      environment = "${var.web_service_environment}"
      port_mappings = [
        {
          name          = "${local.prefix}-web"
          containerPort = "${var.web_service_port}"
          protocol      = "tcp"
        }
      ]
      readonly_root_filesystem  = false
      enable_cloudwatch_logging = true
      log_configuration = {
        log_driver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/${local.prefix}-web"
          awslogs-region        = "${var.region}"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  }
  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.ecs_service_namespace.http_name
    service = {
      client_alias = {
        port     = var.web_service_port
        dns_name = "${local.prefix}-web"
      }
      port_name      = "${local.prefix}-web"
      discovery_name = "${local.prefix}-web"
    }
  }

  load_balancer = {
    service = {
      target_group_arn = aws_lb_target_group.this.arn
      container_name   = "web"
      container_port   = "${var.web_service_port}"
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    http_ingress = {
      description              = "Allow HTTP ingress"
      type                     = "ingress"
      from_port                = "${var.web_service_port}"
      to_port                  = "${var.web_service_port}"
      protocol                 = "tcp"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_cloudwatch_log_group" "ecs_web" {
  name              = "/aws/ecs/${local.prefix}-web"
  retention_in_days = 30
}
