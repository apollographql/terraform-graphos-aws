terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.17.0"
    }
  }
}

// Lattice Service
module "lattice" {
  source = "../lattice-service"

  prefix                         = var.prefix
  tags                           = var.tags
  principal_tags                 = var.principal_tags
  graphos_organizational_unit_id = var.graphos_organizational_unit_id
  graphos_account_id             = var.graphos_account_id
}

// Target groups for the Lambda functions
resource "aws_vpclattice_target_group" "this" {
  for_each = var.lambda_function_arns

  name = "${var.prefix}-${each.key}"
  type = "LAMBDA"

  tags = var.tags
}

resource "aws_vpclattice_target_group_attachment" "this" {
  for_each = var.lambda_function_arns

  target_group_identifier = aws_vpclattice_target_group.this[each.key].id
  target {
    id = each.value
  }
}

// Allow VPC Lattice to invoke the Lambda functions
resource "aws_lambda_permission" "this" {
  for_each = var.lambda_function_arns

  statement_id  = "${var.prefix}-allow-vpc-lattice"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "vpc-lattice.amazonaws.com"
  source_arn    = aws_vpclattice_target_group.this[each.key].arn
}

// Listeners for Lambda functions
resource "aws_vpclattice_listener_rule" "lambda" {
  for_each = var.lambda_function_arns

  name                = "${var.prefix}-${each.key}"
  listener_identifier = module.lattice.lattice_listener_arn
  service_identifier  = module.lattice.lattice_service_arn
  priority            = index([for key, _ in var.lambda_function_arns : key], each.key) + 1

  // When the path starts with `/{subgraph_name}/`
  match {
    http_match {
      path_match {
        case_sensitive = true
        match {
          prefix = "/${each.key}/"
        }
      }
    }
  }

  // Send to the target group ARN
  action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.this[each.key].arn
        weight                  = 1
      }
    }
  }
}
