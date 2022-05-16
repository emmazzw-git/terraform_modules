# Encrypted S3 Bucket

This module deploys the following resources:

* S3 Bucket
* Bucket ACL
* Bucket Server Sided Encryption
* Default Bucket Policy
* Bucket Public Access Block
* Bucket Lifecycle for objects expiration (conditional)

## Usage

```
data "aws_iam_policy_document" "my_bucket_policy" {
  statement {
    sid = "CloudFront"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ABCDE123456789"]
    }
    actions   = ["GetObject"]
    resources = ["arn:aws:s3:::my-bucket/*"]
    effect    = "Allow"
  }
}

module "s3_bucket" {
  source                        = "git::https://github.com/protonmedia/terraform_modules.git//encrypted_s3_bucket?ref=<git commit sha>"
  name                          = "my-bucket"
  number_of_days_objects_expire = 1 # optional
  policy                        = jsonencode(data.aws_iam_policy_document.my_bucket_policy.json)
}
```

## Outputs

| Name | Example |
|------|---------|
| bucket_id | `my-bucket` |
| bucket_arn | `arn:aws:s3:::my-bucket` |
| bucket_domain_name | `my-bucket.s3.amazonaws.com` |
| bucket_regional_domain_name | `my-bucket.s3.us-east-1.amazonaws.com` |
