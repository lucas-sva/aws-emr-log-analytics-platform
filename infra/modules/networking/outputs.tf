output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  description = "Lista de IDs das subnets privadas para deploy seguro"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "Lista de IDs das subnets públicas"
  value       = aws_subnet.public[*].id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}