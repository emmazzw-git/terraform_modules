# KMS Key

This module deploys the following resources:

* KMS Key with AWS default policy
* KMS Alias

## Usage

```
data "aws_iam_policy_document" "my_policy" {
  statement {
    sid = "My custom policy"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions   = ["kms:GenerateDataKey*", "kms:Decrypt"]
    resources = ["*"]
    effect    = "Allow"
  }
}

module "kms_key" {
  source                  = "git::https://github.com/protonmedia/terraform_modules.git//kms_key?ref=<git commit sha>"
  description             = "Key used to encrypt my CloudWatch Logs"
  alias                   = "my-application"
  deletion_window_in_days = 14 # optional (default 7)
  policy                  = jsonencode(data.aws_iam_policy_document.my_policy.json)
}
```

## Outputs

| Name | Example |
|------|---------|
| key_id | `1234abcd-12ab-34cd-56ef-1234567890ab` |
| key_arn | `arn:aws:kms:us-east-1:123456789111:key/1234abcd-12ab-34cd-56ef-1234567890ab` |
| alias_arn | `arn:aws:kms:us-east-1:123456789111:alias/my-application` |
