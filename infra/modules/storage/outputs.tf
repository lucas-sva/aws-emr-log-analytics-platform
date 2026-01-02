output "bucket_names" {
  description = "Mapeamento dos nomes dos buckets criados"
  value       = {for key, value in aws_s3_bucket.this : key => value.id}
}

output "bucket_arns" {
  description = "Mapeamento dos ARNs dos buckets para políticas de IAM"
  value       = {for key, value in aws_s3_bucket.this : key => value.arn}
}