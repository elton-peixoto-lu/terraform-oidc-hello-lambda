variable "aws_region" {
  description = "AWS region for bootstrap resources."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name prefix."
  type        = string
  default     = "terraform-oidc-hello-lambda"
}

variable "github_owner" {
  description = "GitHub owner or organization."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name."
  type        = string
}

variable "github_main_branch" {
  description = "Protected default branch."
  type        = string
  default     = "main"
}

variable "github_environment" {
  description = "GitHub environment used by apply."
  type        = string
  default     = "prod"
}

variable "create_github_oidc_provider" {
  description = "Create a dedicated GitHub OIDC provider in AWS."
  type        = bool
  default     = true
}

variable "existing_github_oidc_provider_arn" {
  description = "Existing GitHub OIDC provider ARN when reusing a shared provider."
  type        = string
  default     = null
}
