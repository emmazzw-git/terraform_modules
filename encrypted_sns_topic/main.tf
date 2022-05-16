resource "aws_sns_topic" "this" {
  display_name      = var.name
  kms_master_key_id = "alias/aws/sns"
}
