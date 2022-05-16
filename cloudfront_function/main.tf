resource "aws_cloudfront_function" "this" {
  name    = var.function_name
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file(var.function_path)
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/cloudfront/function/${var.function_name}"
  retention_in_days = var.retention_log_in_days
}
