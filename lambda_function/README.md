# Lambda Function

This module deploys the following resources:

* Lambda Function
* Lambda Layers
* IAM Role with policies
* CloudWatch Log Group

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

module "lambda" {
  source                  = "git::https://github.com/protonmedia/terraform_modules.git//lambda_function?ref=<git commit sha>"
  name                    = "hello-world"
  description             = "This is a hello world lambda function"
  architecture            = "x86_64" # optional (defaults to x86_64)
  environment_variables   = {
    mysecret              = 'hello'
  }
  runtime                 = "python3.9" # optional (defaults to python 3.9)
  memory_size             = 128 # optional (deafults to 128)
  timeout                 = 5 # optional (defaults to 3)
  retention_log_in_days   = 1 # optional (defaults to 7)
  custom_policies         = [data.aws_iam_policy_document.my_policy.json]
  lambdaFilename          = "${path.module}/dist/function.zip"
  layerFilename           = "${path.module}/dist/dependencies.zip"
  handler                 = "function.lambda_handler" # optional (defaults to "function.lambda_handler")
}
```

## Outputs

| Name | Example |
|------|---------|
| lambda_arn | `arn:aws:lambda:us-east-1:000000000000:function:myfunction` |
| layer_arn | `arn:aws:lambda:us-east-1:000000000000:layer:myfunction_dependencies:4` |
| role_arn | `arn:aws:iam::000000000000:role/function-role` |
| cloudwatch_log_group | `arn:aws:logs:us-east-1:000000000000:log-group:/aws/lambda/myfunction:*` |
