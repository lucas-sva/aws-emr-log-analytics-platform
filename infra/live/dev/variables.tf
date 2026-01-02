variable "aws_region" {
  type = string
  default = "us-east-2"
}

variable "project_name" {
  description = "Nome do projeto para taggear recursos"
  type        = string
  default     = "emr-log-analytics"
}

variable "environment" {
  description = "Ambiente (dev, prod, staging)"
  type        = string
  default     = "dev"
}

# Variáveis networking
variable "vpc_cidr" {
  description = "Bloco CIDR principal da VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "Lista de CIDRs para subnets públicas (NAT, Load Balancers)"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "Lista de CIDRs para subnets privadas (EMR, Lambda)"
  type        = list(string)
}

variable "availability_zones" {
  description = "Zonas de Disponibilidade para distribuir a rede"
  type        = list(string)
}