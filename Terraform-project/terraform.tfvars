region = "eu-north-1"

vpc_cidr = "10.0.0.0/16"

public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

azs = ["eu-north-1a", "eu-north-1b"]

ami = "ami-05d62b9bc5a6ca605"
instance_type = "t3.micro"
desired_capacity = 2

