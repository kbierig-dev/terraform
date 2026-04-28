terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-898711548801"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

moved {
  from = module.s3_bucket
  to   = module.deployment_bucket
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "terraform"
      Project     = "example-project"
    }
  }
}

# Core S3 bucket for deployments
module "deployment_bucket" {
  source = "../../modules/example_module"

  bucket_name = "example-dev-bucket-${var.environment_identifier}"
  environment = "dev"
}

# In-Stock Checker Lambda
module "in_stock_lambda" {
  source = "../../modules/lambda_function"

  function_name = "in-stock-checker-dev"
  
  s3_bucket = module.deployment_bucket.bucket_name
  s3_key    = "deployments/in-stock.zip"
  
  handler   = "main.lambda_handler"

  environment_variables = {
    URL          = var.target_url
    APP_ID       = var.target_app_id
    SUB_ID       = var.target_sub_id
    PHONE_NUMBER = var.alert_phone_number
    ENVIRONMENT  = "dev"
  }
}

# Setup OIDC for GitHub Actions (Secure CI/CD)
module "github_oidc" {
  source = "../../modules/github_oidc"
}

# --- Outputs ---

output "github_actions_role_arn" {
  value       = module.github_oidc.role_arn
  description = "Paste this into GitHub Secrets as AWS_ROLE_ARN"
}

output "deployment_bucket_name" {
  value       = module.deployment_bucket.bucket_name
  description = "The S3 bucket where Lambda zips should be uploaded"
}

output "lambda_function_name" {
  value       = "in-stock-checker-dev"
  description = "The name of the deployed Lambda function"
}
