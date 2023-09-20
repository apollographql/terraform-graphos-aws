resource "aws_vpclattice_service" "this" {
  name      = "${var.prefix}-subgraphs"
  auth_type = "AWS_IAM"

  tags = var.tags
}

// IAM Policy to restrict traffic from Apollo GraphOS only
resource "aws_vpclattice_auth_policy" "this" {
  resource_identifier = aws_vpclattice_service.this.arn
  policy              = data.aws_iam_policy_document.graphos_policy.json
}

data "aws_iam_policy_document" "graphos_policy" {
  statement {
    effect = "Allow"

    // Safe due to the `aws:PrincipalOrgPaths` condition
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "vpc-lattice-svcs:Invoke"
    ]

    resources = ["*"]

    // Restrict to encrypted traffic only
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [true]
    }

    // Restrict to port 443 (HTTPS)
    condition {
      test     = "NumericEquals"
      variable = "vpc-lattice-svcs:Port"
      values   = [443]
    }

    // Restrict to Apollo GraphOS AWS Organization ID
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["o-9vaxczew6u"]
    }

    // Restrict to the AWS Organizational Unit used by Apollo GraphOS
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values   = ["o-9vaxczew6u/*/ou-leyb-l9pccq2t/${var.graphos_organizational_unit_id}/*"]
    }
  }
}

// Listener on HTTPS:443
resource "aws_vpclattice_listener" "this" {
  name        = "${var.prefix}-subgraphs"
  port        = 443
  protocol    = "HTTPS"
  service_arn = aws_vpclattice_service.this.arn

  tags = var.tags
}

// Listener for ALBs
resource "aws_vpclattice_listener_rule" "alb" {
  // TODO: only create if there are ALB subgraphs

  name                = "${var.prefix}-alb"
  listener_identifier = aws_vpclattice_listener.this.arn
  service_identifier  = aws_vpclattice_service.this.arn
  priority            = 0


}

// Listeners for Lambda functions
resource "aws_vpclattice_listener_rule" "lambda" {
  for_each = module.lambda_subgraphs.lattice_target_groups

  name                = "${var.prefix}-${each.key}"
  listener_identifier = aws_vpclattice_listener.this.arn
  service_identifier  = aws_vpclattice_service.this.arn
  priority            = index(module.lambda_subgraphs.lattice_target_groups, each.key) + 1

  // When the path starts with `/{subgraph_name}/`
  match {
    http_match {
      path_match {
        case_sensitive = true
        match {
          prefix = "/${each.name}/"
        }
      }
    }
  }

  // Send to the target group ARN
  action {
    forward {
      target_groups {
        target_group_identifier = each.value.arn
        weight                  = 1
      }
    }
  }
}
