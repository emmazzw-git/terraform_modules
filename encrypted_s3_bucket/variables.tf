variable "name" {
  type        = string
  description = "The name of the S3 Bucket"
}

variable "number_of_days_objects_expire" {
  type        = number
  default     = 0
  description = "The number of days you want the S3 Bucket objects to automatically expire."
}

variable "bucket_policy" {
  type        = string
  description = "Custom Bucket Policy"
}
