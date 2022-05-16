output "key_id" {
  value       = aws_kms_key.this.id
  description = "The globally unique identifier for the key"
}

output "key_arn" {
  value       = aws_kms_key.this.arn
  description = "The Amazon Resource Name (ARN) of the key"
}

output "alias_arn" {
  value       = aws_kms_alias.this.arn
  description = "The Amazon Resource Name (ARN) of the key alias"
}

output "alias" {
  value       = "alias/${var.alias}"
  description = "The key alias"
}
