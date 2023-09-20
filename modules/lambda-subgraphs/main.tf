terraform {
  required_version = ">=1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.17.0"
    }
  }
}

// Target groups for the Lambda functions
resource "aws_vpclattice_target_group" "this" {
  for_each = var.lambda_function_arns

  name = "${var.prefix}-lambda-${each.key}"
  type = "LAMBDA"

  tags = var.tags
}

resource "aws_vpclattice_target_group_attachment" "this" {
  for_each = var.lambda_function_arns

  target_group_identifier = aws_vpclattice_target_group.this[each.key].id
  target = {
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
