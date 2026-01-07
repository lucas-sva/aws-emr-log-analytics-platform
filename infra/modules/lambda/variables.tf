variable "project_name" {
  description = "Project name to be used for tagging and naming resources"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "emr_cluster_id" {
  description = "ID of the EMR Cluster to submit steps to"
  type        = string
}

# --- Storage Configuration ---
variable "raw_bucket_id" {
  description = "ID of the Raw bucket"
  type        = string
}

variable "raw_bucket_arn" {
  description = "ARN of the Raw bucket"
  type        = string
}

variable "processed_bucket_name" {
  description = "Name of the Processed bucket"
  type        = string
}

# --- Lambda Configuration ---
variable "lambda_runtime" {
  description = "Python runtime version"
  type        = string
  default     = "python3.12"
}

variable "lambda_timeout" {
  description = "Lambda execution timeout in seconds"
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 128
}