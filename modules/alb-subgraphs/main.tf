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

  default_target_group = aws_vpclattice_target_group.this.arn
}

resource "aws_vpclattice_target_group" "this" {
  name = "${var.prefix}-alb"
  type = "ALB"

  config {
    port           = var.alb_port
    protocol       = "HTTP"
    vpc_identifier = var.vpc_id
  }

  tags = var.tags
}

resource "aws_vpclattice_target_group_attachment" "this" {
  target_group_identifier = aws_vpclattice_target_group.this.arn

  target {
    id   = var.alb_arn
    port = var.alb_port
  }
}
