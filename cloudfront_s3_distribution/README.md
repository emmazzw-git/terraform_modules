# CloudFront S3 Distribution

This module deploys the following resources:

* CloudFront Distribution
* Certificate
* Web Application Firewall
* CloudWatch Metrics

## Usage

```
data "aws_iam_policy_document" "cloudfront_bucket_policy" {
  statement {
    sid = "CloudFront"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.cloudfront_oai.id}"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::my-bucket/*"]
    effect    = "Allow"
  }
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = 'my-bucket'
}

module "s3_bucket" {
  source        = "git::https://github.com/protonmedia/terraform_modules.git//encrypted_s3_bucket?ref=<COMMIT>"
  name          = 'my-bucket'
  bucket_policy = jsonencode(data.aws_iam_policy_document.cloudfront_bucket_policy.json)
}

module "cloudfront_function" {
  source                = "git::https://github.com/protonmedia/terraform_modules.git//cloudfront_function?ref=<COMMIT>"
  function_path         = "${path.module}/function.js"
  function_name         = "my-func"
}

module "cloudfront" {
  source                          = "git::https://github.com/protonmedia/terraform_modules.git//cloudfront_s3_distribution?ref=<COMMIT>"
  s3_bucket_name                  = 'my-bucket'
  s3_folder_path                  = '/my-subfolder'
  alternate_domain_name           = ['example.com']
  bucket_regional_domain_name     = module.s3_bucket.bucket_regional_domain_name
  whitelisted_ip_addresses        = ["1.2.3.4/32"]
  cloudfront_access_identity_path = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
  function_associations           = [
    {
      event_type   = "viewer-request"
      function_arn = module.cloudfront_function.function_arn
    }
  ]
}
```

## Outputs

| Name | Example |
|------|---------|
| waf_arn | `arn:aws:wafv2:us-east-1:044793301743:global/webacl/test/709d8860-9b00-47e0-baf2-f474d6c52569` |
| waf_id | `709d8860-9b00-47e0-baf2-f474d6c52569` |
| distribution_arn | `arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5` |
| distribution_id | `EDFDVBD632BHDS5` |
