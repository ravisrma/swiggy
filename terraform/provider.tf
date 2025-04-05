provider "aws" {
  region = var.region # Replace with your desired AWS region 
}

terraform {
  backend "s3" {
    bucket  = "ecs-terraform-bucket0"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}