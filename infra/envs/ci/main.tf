module "hello_lambda" {
  source       = "../../modules/hello_lambda"
  project_name = var.project_name
}

output "lambda_name" {
  value = module.hello_lambda.lambda_name
}

output "lambda_arn" {
  value = module.hello_lambda.lambda_arn
}

