provider "aws" {
  region = var.region # Replace with your desired AWS region 
}
terraform {
  backend "s3" {
    bucket = "ecs-terraform-bucket0" # Replace with your bucket name
    key    = "terraform.tfstate"     # its upto you
    region = "ap-south-1"                # Replace with your region name
  }
}