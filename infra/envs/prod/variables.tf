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

