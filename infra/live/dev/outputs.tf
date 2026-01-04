output "dev_bucket_names" {
  description = "Nomes dos buckets criados no ambiente de dev"
  value       = module.storage.bucket_names
}

output "emr_cluster_id" {
  description = "O ID do Cluster EMR criado"
  value       = module.emr.cluster_id
}

output "emr_cluster_name" {
  description = "Nome do Cluster"
  value       = module.emr.cluster_name
}

output "emr_master_public_dns" {
  description = "DNS Público do Master (Vazio se estiver em subnet privada)"
  value       = module.emr.master_public_dns
}

output "emr_service_role" {
  description = "ARN da Role de Serviço usada"
  value       = module.emr.service_role_arn
}