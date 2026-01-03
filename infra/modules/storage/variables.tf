variable "project_name" {
  description = "Project name to generate unique bucket names"
  type        = string
}

variable "environment" {
  description = "Environment context"
  type        = string
}

variable "buckets" {
  description = "List of logical bucket names (e.g., raw, processed, administrative)"
  type        = list(string)
}