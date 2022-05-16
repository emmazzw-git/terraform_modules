output "slack_configuration_arn" {
  description = "The ARN of the Chatbot Slack configuration"
  value       = module.chatbot_slack_configuration.configuration_arn
}

output "stack_id" {
  description = "The unique identifier for the stack."
  value       = module.chatbot_slack_configuration.stack_id
}
