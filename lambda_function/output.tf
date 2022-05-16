output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "The Lambda Function ARN"
}

output "layer_arn" {
  value       = aws_lambda_layer_version.this.arn
  description = "The Lambda Function Layer ARN"
}

output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "The Lambda Function Role ARN"
}

output "cloudwatch_log_group" {
  value       = aws_cloudwatch_log_group.this.arn
  description = "The Lambda CloudWatch Group ARN"
}
