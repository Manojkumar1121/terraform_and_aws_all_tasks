variable "vpc_id" {}
variable "private_subnets" { type = list(string) }
variable "target_group_arn" {}
variable "alb_sg" {}

variable "ami" {}
variable "instance_type" {}
variable "desired_capacity" {}
