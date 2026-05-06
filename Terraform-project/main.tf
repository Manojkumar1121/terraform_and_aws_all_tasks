provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "s3-bucketnew-task"   
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "Dynamo-DB"
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["eu-north-1a", "eu-north-1b"]
}

module "alb" {
  source = "./modules/alb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  target_group_arn = module.alb.target_group_arn
  alb_sg           = module.alb.alb_sg   

  ami              = var.ami
  instance_type    = var.instance_type
  desired_capacity = var.desired_capacity
}


