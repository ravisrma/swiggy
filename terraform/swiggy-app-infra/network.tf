locals {
  azs = formatlist("${data.aws_region.current.name}%s", ["a", "b", "c"])
}
data "aws_region" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.prefix}-${var.environment}"
  cidr = var.vpc_cidr
  azs  = local.azs
  private_subnets = [
    for index in range(length(local.azs)) :
    cidrsubnet(var.vpc_cidr, 8, index)
  ]
  public_subnets = [
    for index in range(length(local.azs)) :
    cidrsubnet(var.vpc_cidr, 8, index + length(local.azs))
  ]
  tags               = local.tags

  enable_nat_gateway = true
  single_nat_gateway = true
}