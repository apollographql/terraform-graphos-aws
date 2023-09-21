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

  dynamic "default_action" {
    for_each = length(var.default_target_group) == 0 ? toset([404]) : toset([])

    content {
      fixed_response {
        status_code = 404
      }
    }
  }

  dynamic "default_action" {
    for_each = length(var.default_target_group) != 0 ? toset([var.default_target_group]) : toset([])
    content {
      forward {
        target_groups {
          target_group_identifier = var.default_target_group
          weight                  = 1
        }
      }
    }
  }

  tags = var.tags
}
