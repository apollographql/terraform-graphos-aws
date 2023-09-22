terraform {
  required_version = ">=1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.17.0"
    }
  }
}

// ALB subgraphs
module "alb_subgraphs" {
  for_each = var.alb_subgraphs

  source = "./modules/alb-subgraphs"

  prefix                         = "${var.prefix}-alb-${each.key}"
  graphos_account_id             = var.graphos_account_id
  graphos_organizational_unit_id = var.graphos_organizational_unit_id
  tags                           = var.tags

  vpc_id  = each.value.vpc_id
  alb_arn = each.value.alb_arn

}

// Lambda subgraphs
module "lambda_subgraphs" {
  // Only create this module if there are Lambda function ARNs
  count = length(var.lambda_subgraphs) > 0 ? 1 : 0

  source = "./modules/lambda-subgraphs"

  prefix                         = "${var.prefix}-lambda"
  graphos_account_id             = var.graphos_account_id
  graphos_organizational_unit_id = var.graphos_organizational_unit_id
  tags                           = var.tags

  lambda_function_arns = { for name, value in var.lambda_subgraphs : name => value.lambda_function_arn }
}
