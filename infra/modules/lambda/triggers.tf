# Permissão pro S3 chamar o lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.raw_bucket_arn
}

# Configuração do evento no bucket
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.raw_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
    filter_prefix       = "logs/"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}