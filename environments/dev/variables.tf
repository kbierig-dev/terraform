variable "aws_region" {
  description = "The AWS region to deploy the resources to."
  type        = string
  default     = "us-east-1"
}

variable "environment_identifier" {
  description = "A unique identifier for the dev environment to prevent naming collisions."
  type        = string
  default     = "001"
}

# Sensitive Variables - These should be provided via terraform.tfvars
variable "target_url" {
  description = "The target API URL for the checker"
  type        = string
  sensitive   = true
}

variable "target_app_id" {
  description = "Target App ID"
  type        = string
  sensitive   = true
}

variable "target_sub_id" {
  description = "Target Sub ID"
  type        = string
  sensitive   = true
}

variable "alert_phone_number" {
  description = "Phone number for SNS alerts"
  type        = string
  sensitive   = true
}
