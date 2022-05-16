resource "aws_iam_role" "chatbot_role" {
  name               = "AWSChatbot-${var.slack_channel_name}-Slack-Role"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.chatbot_role_policy.json
  inline_policy {
    name   = "AWS-Chatbot-NotificationsOnly-Policy"
    policy = data.aws_iam_policy_document.chatbot_policy.json
  }
}

module "chatbot_slack_configuration" {
  source  = "waveaccounting/chatbot-slack-configuration/aws"
  version = "1.1.0"

  configuration_name = var.slack_channel_name
  iam_role_arn       = aws_iam_role.chatbot_role.arn
  logging_level      = "ERROR"
  slack_channel_id   = var.slack_channel_id
  slack_workspace_id = var.slack_workspace_id
  sns_topic_arns     = var.sns_topic_arns
}
