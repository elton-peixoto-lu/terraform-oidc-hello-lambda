terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.5"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = var.skip_aws_credentials_validation
  skip_metadata_api_check     = var.skip_aws_credentials_validation
  skip_requesting_account_id  = var.skip_aws_credentials_validation
  skip_region_validation      = var.skip_aws_credentials_validation
}

