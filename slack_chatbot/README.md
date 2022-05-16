# Slack Chatbot

This module deploys the following resources:

* AWS Chatbot
* IAM Role
* AWS Cloudformation Stack

## Usage

```
module "my_chatbot" {
  source              = "git::https://github.com/protonmedia/terraform_modules.git//slack_chatbot?ref=<git commit sha>"
  slack_channel_name  = "general"
  slack_channel_id    = "C0271U4MBS6"
  slack_workspace_id  = "T02BQFRTW"
  sns_topic_arns      = [ "arn:aws:sns:ap-southeast-2:123456789012:my-sns" ]
}
```

## Notes

You must create a Slack workspace manually through the AWS Console.

## Outputs

| Name | Example |
|------|---------|
| slack_configuration_arn | `arn:aws:chatbot::000000000000:chat-configuration/slack-channel/my-test` |
| stack_id | `arn:aws:cloudformation:us-east-1:000000000000:stack/my-stack` |
