variable "slack_channel_name" {
  type        = string
  description = "The name of the Slack Channel"
}

variable "slack_channel_id" {
  type        = string
  description = "The ID of the Slack Channel."
}

variable "slack_workspace_id" {
  type        = string
  description = "The ID of the Slack workspace authorized with AWS Chatbot."
}

variable "sns_topic_arns" {
  type        = list(string)
  description = "List of SNS Arn's where the CloudWatch notifications are sent to."
  default     = []
}
