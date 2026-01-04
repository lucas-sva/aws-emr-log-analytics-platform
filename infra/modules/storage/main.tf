resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "this" {
  for_each      = toset(var.buckets)
  bucket        = "${var.project_name}-${var.environment}-${each.value}-${random_string.suffix.result}"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-${each.value}"
    Environment = var.environment
    Layer       = each.value
  }
}

# Bloqueio de Acesso Público (Essential Hardening)
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = aws_s3_bucket.this
  bucket   = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Criptografia (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = aws_s3_bucket.this
  bucket   = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}