resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "sns_publish" {
  name = "sns_publish"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "this" {
  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key
  
  s3_object_version = var.s3_object_version

  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = "python3.12"
  timeout       = 30
  
  publish = true

  environment {
    variables = var.environment_variables
  }
}

# Create an Alias for the Lambda
resource "aws_lambda_alias" "this" {
  count            = var.alias_name != null ? 1 : 0
  name             = var.alias_name
  function_name    = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

variable "function_name" {
  type = string
}

variable "handler" {
  type    = string
  default = "main.lambda_handler"
}

variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "s3_object_version" {
  description = "The version of the S3 object to deploy"
  type        = string
  default     = null
}

variable "alias_name" {
  description = "The name of the Lambda alias (e.g. live, prod)"
  type        = string
  default     = null
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

output "function_arn" {
  value = aws_lambda_function.this.arn
}

output "alias_arn" {
  value = var.alias_name != null ? aws_lambda_alias.this[0].arn : null
}
