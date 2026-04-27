variable "bucket_name" {
  description = "The name of the bucket to create."
  type        = string
}

variable "environment" {
  description = "The environment name for tagging."
  type        = string
  default     = "dev"
}
