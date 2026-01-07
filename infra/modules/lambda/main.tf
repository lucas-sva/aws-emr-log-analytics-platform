data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../../src/lambda/trigger_emr/lambda_function.py"
  output_path = "${path.module}/dist/lambda_function.zip"
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${var.project_name}-${var.environment}-trigger-emr"
  role          = aws_iam_role.this.arn
  handler       = "lambda_function.lambda_handler"

  # Garante deploy apenas se o código mudar
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime     = var.lambda_runtime
  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = {
      EMR_CLUSTER_ID   = var.emr_cluster_id
      PROCESSED_BUCKET = var.processed_bucket_name
    }
  }

  tags = var.tags
}