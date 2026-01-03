variable "project_name" {
  description = "Project name to be used for tagging and naming resources"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of Private Subnet IDs for the cluster"
  type        = list(string)
}

variable "release_label" {
  description = "EMR Release version (e.g., emr-7.1.0)"
  type        = string
  default     = "emr-7.1.0"
}

variable "applications" {
  description = "List of applications to install (Spark, Flink, Hadoop, etc.)"
  type        = list(string)
  default     = ["Hadoop", "Spark", "Flink", "Hive", "JupyterEnterpriseGateway"]
}

# --- Buckets (Passados pelo módulo Storage) ---
variable "s3_bucket_log_id" {
  description = "Bucket ID for EMR logs"
  type        = string
}

# --- Hardware & FinOps (Instance Fleets) ---
variable "master_instance_type" {
  description = "Instance type for the Master node (On-Demand)"
  type        = string
  default     = "m5.xlarge"
}

variable "core_instance_type" {
  description = "Instance type for Core nodes (On-Demand, HDFS storage)"
  type        = string
  default     = "m5.xlarge"
}

variable "task_instance_types" {
  description = "List of instance types for Task nodes (Spot candidates)"
  type        = list(string)
  default     = ["m5.xlarge", "r5.xlarge", "c5.xlarge"] # O Fleet vai tentar pegar a mais barata dessas
}

variable "core_instance_count" {
  description = "Number of Core nodes (On-Demand)"
  type        = number
  default     = 1
}

variable "task_spot_target_capacity" {
  description = "Number of Task nodes (Spot) desired"
  type        = number
  default     = 2
}