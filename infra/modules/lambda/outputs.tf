output "lambda_function_arn" {
  description = "ARN of the created Lambda function"
  value       = aws_lambda_function.this.arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM Role attached to Lambda"
  value       = aws_iam_role.this.arn
}