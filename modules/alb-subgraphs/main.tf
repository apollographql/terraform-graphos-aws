resource "aws_vpclattice_target_group" "this" {
  name = "${var.prefix}-alb"
  type = "ALB"

  tags = var.tags
}

resource "aws_vpclattice_target_group_attachment" "this" {
  target_group_identifier = aws_vpclattice_target_group.this.arn

  target = {
    id   = aws_lb.this.arn
    port = 80
  }
}

resource "aws_lb" "this" {
  name                       = "${var.prefix}-subgraphs"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = var.security_group_ids
  subnets                    = var.subnet_ids
  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  tags = var.tags
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.alb_target_group_arns

  listener_arn = aws_lb_listener.this.arn
  priority     = index(var.alb_target_group_arns, each.key)

  // When the path starts with `/{subgraph_name}/`
  condition {
    path_pattern {
      values = ["/${each.value}/*"]
    }
  }

  // Send to the target group ARN
  action {
    type             = "forward"
    target_group_arn = each.value
  }
}
