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
  # Use S3 instead of local filename
  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = "python3.12"
  timeout       = 30

  environment {
    variables = var.environment_variables
  }
}

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
  description = "The S3 bucket containing the lambda zip"
  type        = string
}

variable "s3_key" {
  description = "The S3 key (path) to the lambda zip"
  type        = string
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}
