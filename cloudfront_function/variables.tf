variable "function_path" {
  type        = string
  description = "Path to the function source code."
}

variable "function_name" {
  type        = string
  description = "Name of the function."
}

variable "retention_log_in_days" {
  type        = number
  description = "Number of days CloudWatch retains the Lambda logs"
  default     = 1
}
