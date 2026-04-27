terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Example backend configuration, uncomment and adjust to your needs
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
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
