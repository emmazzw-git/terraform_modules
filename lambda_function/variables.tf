variable "name" {
  type        = string
  description = "The name of the lambda function"
}

variable "description" {
  type        = string
  description = "The lambda function description"
}

variable "architecture" {
  type        = string
  description = "The lambda function architecture"
  default     = "x86_64"
  validation {
    condition     = can(regex("^(x86_64|arm64)$", var.architecture))
    error_message = "Architecture variable is not valid."
  }
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "runtime" {
  type        = string
  description = "The lambda function runtime"
  default     = "python3.9"
  validation {
    condition     = can(regex("^(nodejs|nodejs4.3|nodejs6.10|nodejs8.10|nodejs10.x|nodejs12.x|nodejs14.x|java8|java8.al2|java11|python2.7|python3.6|python3.7|python3.8|python3.9|dotnetcore1.0|dotnetcore2.0|dotnetcore2.1|dotnetcore3.1|nodejs4.3-edge|go1.x|ruby2.5|ruby2.7|provided|provided.al2)$", var.runtime))
    error_message = "Runtime variable is not valid."
  }
}

variable "memory_size" {
  type        = number
  description = "The lambda memory size"
  default     = 128
}

variable "timeout" {
  type        = number
  description = "Amount of time your Lambda Function has to run in seconds."
  default     = 3
}

variable "retention_log_in_days" {
  type        = number
  description = "Number of days CloudWatch retains the Lambda logs"
  default     = 7
}

variable "custom_policies" {
  type        = list(string)
  description = "The lambda custom policies (stringyfied JSON)"
  default     = []
}

variable "lambdaFilename" {
  type        = string
  description = "Path to the zipped lambda function (e.g.: ./dist/function.zip)"
}

variable "layerFilename" {
  type        = string
  description = "Path to the zipped lambda layer (e.g.: ./dist/dependencies.zip)"
}

variable "handler" {
  type        = string
  description = "The Lambda Handler"
  default     = "function.lambda_handler"
}
