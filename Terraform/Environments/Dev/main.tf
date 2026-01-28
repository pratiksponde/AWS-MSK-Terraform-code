terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }
}

provider "aws" {
    region = var.region
}

module "VPC" {
    source = "../../Modules/VPC"
    name = "Dev-MSK"
    vpc_cidr = var.vpc_cidr
    az_count = var.az_count
}

module "MSK-Serverless" {
    source = "../../Modules/MSK-Serverless"
    cluster_name = var.cluster_name
    vpc_id = module.VPC.vpc_id
    subnet_ids = module.VPC.private_subnet_ids
    allowed_cidr = var.allowed_cidr

    tags = {
      Environment = var.Environment
    }
}