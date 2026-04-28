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

# Example of consuming a local module
module "s3_bucket" {
  source = "../../modules/example_module"

  bucket_name = "example-dev-bucket-${var.environment_identifier}"
  environment = "dev"
}

module "in_stock_lambda" {
  source = "../../modules/lambda_function"

  function_name = "in-stock-checker-dev"
  
  # Pointing to the bucket we created earlier
  s3_bucket = module.s3_bucket.bucket_name
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
