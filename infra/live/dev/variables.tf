variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "emr-log-analytics"
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Mapa de tags padrão para aplicar em todos os recursos"
  type        = map(string)
  default = {
    Project   = "EMR-Log-Analytics"
    ManagedBy = "Terraform"
    Owner     = "Data Engineering"
  }
}

# --- Networking (estão no tfvars) ---
variable "vpc_cidr" {
  description = "CIDR VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "CIDRs Públicas"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "CIDRs Privadas"
  type        = list(string)
}

variable "availability_zones" {
  description = "AZs"
  type        = list(string)
}

variable "buckets" {
  description = "Nomes lógicos dos buckets"
  type        = list(string)
  default     = ["raw", "processed", "administrative"]
}