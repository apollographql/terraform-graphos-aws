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
  // TODO: only create if there are ALB subgraphs

  source = "./modules/alb-subgraphs"

  prefix                     = var.prefix
  tags                       = var.tags
  vpc_id                     = var.alb_vpc_id
  subnet_ids                 = var.alb_subnet_ids
  security_group_ids         = var.alb_security_group_ids
  alb_target_group_arns      = var.alb_target_group_arns
  enable_deletion_protection = var.enable_deletion_protection
}

// Lambda subgraphs
module "lambda_subgraphs" {
  source = "./modules/lambda-subgraphs"

  prefix               = var.prefix
  lambda_function_arns = var.lambda_function_arns
  tags                 = var.tags
}
