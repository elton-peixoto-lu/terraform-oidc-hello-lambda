variable "aws_region" {
  description = "AWS region to deploy the Lambda."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name prefix."
  type        = string
  default     = "terraform-oidc-hello-lambda"
}

variable "skip_aws_credentials_validation" {
  description = "Allow offline Terraform planning in CI before OIDC bootstrap variables are configured."
  type        = bool
  default     = false
}

