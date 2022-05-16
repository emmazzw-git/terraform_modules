output "waf_arn" {
  value       = aws_wafv2_web_acl.this.arn
  description = "The Web Application Firewall ARN"
}

output "waf_id" {
  value       = aws_wafv2_web_acl.this.id
  description = "The Web Application Firewall ID"
}

output "distribution_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "The CloudFront Distribution ARN"
}

output "distribution_id" {
  value       = aws_cloudfront_distribution.this.id
  description = "The CloudFront Distribution ID"
}
