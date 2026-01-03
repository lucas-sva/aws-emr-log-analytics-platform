output "cluster_id" {
  description = "The ID of the EMR Cluster"
  value       = aws_emr_cluster.this.id
}

output "cluster_name" {
  description = "The name of the EMR Cluster"
  value       = aws_emr_cluster.this.name
}

output "master_public_dns" {
  description = "Master node public DNS (Empty since we are in private subnets)"
  value       = aws_emr_cluster.this.master_public_dns
}

output "service_role_arn" {
  description = "ARN of the EMR Service Role"
  value       = aws_iam_role.service_role.arn
}
