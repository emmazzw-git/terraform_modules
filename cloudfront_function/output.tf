output "function_arn" {
  value       = aws_cloudfront_function.this.arn
  description = " Amazon Resource Name (ARN) identifying your CloudFront Function."
}

output "cloudwatch_log_group" {
  value       = aws_cloudwatch_log_group.this.arn
  description = "The Lambda CloudWatch Group ARN."
}
