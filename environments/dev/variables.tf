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
