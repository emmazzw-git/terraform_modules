variable "description" {
  type        = string
  description = "The description of the key as viewed in AWS console"
}

variable "alias" {
  type        = string
  description = "The display name of the alias"
}

variable "deletion_window_in_days" {
  type        = number
  default     = 7
  description = "The waiting period, specified in number of days"
}

variable "policy" {
  type        = string
  description = "A valid policy JSON document"
}
