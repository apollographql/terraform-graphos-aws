terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.17.0"
    }
  }
}

locals {
  apollo_account_ids = length(var.apollo_account_ids) > 0 ? {
    "Apollo:accountId" : var.apollo_account_ids
  } : {}
  apollo_graph_refs = length(var.apollo_graph_refs) > 0 ? {
    "Apollo:graphRef" : var.apollo_graph_refs
  } : {}
  principal_tags = merge(local.apollo_account_ids, local.apollo_graph_refs)
}

// ALB subgraphs
module "alb_subgraphs" {
  for_each = var.alb_subgraphs

  source = "./modules/alb-subgraphs"

  prefix                         = "${var.prefix}-alb-${each.key}"
  principal_tags                 = local.principal_tags
  graphos_account_id             = var.graphos_account_id
  graphos_organizational_unit_id = var.graphos_organizational_unit_id
  tags                           = var.tags

  vpc_id   = each.value.vpc_id
  alb_arn  = each.value.alb_arn
  alb_port = each.value.alb_port

}

// Lambda subgraphs
module "lambda_subgraphs" {
  // Only create this module if there are Lambda function ARNs
  count = length(var.lambda_subgraphs) > 0 ? 1 : 0

  source = "./modules/lambda-subgraphs"

  prefix                         = "${var.prefix}-lambda"
  principal_tags                 = local.principal_tags
  graphos_account_id             = var.graphos_account_id
  graphos_organizational_unit_id = var.graphos_organizational_unit_id
  tags                           = var.tags

  lambda_function_arns = { for name, value in var.lambda_subgraphs : name => value.lambda_function_arn }
}
