# Encrypted SNS Topic

This module deploys the following resources:

* SNS Topic
* KMS Key
* KMS Alias

## Usage

```
module "sns_topic" {
  source                  = "git::https://github.com/protonmedia/terraform_modules.git//encrypted_sns_topic?ref=<git commit sha>"
  name                    = "MyTopic"
}
```

## Outputs

| Name | Example |
|------|---------|
| sns_arn | `arn:aws:sns:us-east-1:123456789111:MyTopic` |
