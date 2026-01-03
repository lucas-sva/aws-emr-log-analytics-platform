variable "project_name" {
  description = "Project name for tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment context"
  type        = string
}

variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of Availability Zones to distribute subnets"
  type        = list(string)
}