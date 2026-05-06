output "alb_dns" {
  value = module.alb.alb_dns
}
output "target_group_arn" {
  value = module.alb.target_group_arn
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

