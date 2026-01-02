output "dev_vpc_id" {
  value = module.networking.vpc_id
}

output "dev_private_subnets" {
  value = module.networking.private_subnets
}

output "dev_public_subnets" {
  value = module.networking.public_subnets
}