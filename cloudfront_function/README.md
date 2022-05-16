# CloudFront Function

This module deploys the following resources:

* CloudFront Function
* CloudWatch Log Group

## Usage

```
module "cloudfront_function" {
  source                = "git::https://github.com/protonmedia/terraform_modules.git//cloudfront_function?ref=<git commit sha>"
  function_path         = "${path.module}/function.js"
  function_name         = "my-func"
  retention_log_in_days = 7 # default is 1
}
```

## Outputs

| Name | Example |
|------|---------|
| function_arn | `arn:aws:cloudfront::000000000000:function/my-func` |
| cloudwatch_log_group | `arn:aws:logs:us-east-1:000000000000:log-group:/aws/cloudfront/function/my-func:*` |
