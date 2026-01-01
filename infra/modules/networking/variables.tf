variable "project_name" {
  description = "Nome do projeto para taggear recursos"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod, staging)"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR principal da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "Lista de CIDRs para subnets públicas (NAT, Load Balancers)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnets_cidr" {
  description = "Lista de CIDRs para subnets privadas (EMR, Lambda)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Zonas de Disponibilidade para distribuir a rede"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}