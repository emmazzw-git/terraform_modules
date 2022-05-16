data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "custom_policy_documents" {
  count                     = length(var.custom_policies) > 0 ? 1 : 0
  override_policy_documents = var.custom_policies
}
