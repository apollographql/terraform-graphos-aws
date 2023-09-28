data "aws_alb" "subgraph" {
  arn = var.alb_arn
}

data "aws_alb_listener" "subgraph" {
  load_balancer_arn = var.alb_arn
  port              = var.alb_port
}

data "aws_region" "this" {}

data "aws_ec2_managed_prefix_list" "lattice_ipv4" {
  name = "com.amazonaws.${data.aws_region.this.name}.vpc-lattice"
}

data "aws_ec2_managed_prefix_list" "lattice_ipv6" {
  name = "com.amazonaws.${data.aws_region.this.name}.ipv6.vpc-lattice"
}

data "aws_vpc_security_group_rules" "subgraph" {
  filter {
    name   = "group-id"
    values = data.aws_alb.subgraph.security_groups
  }
}

data "aws_subnet" "subgraph" {
  for_each = data.aws_alb.subgraph.subnets

  id = each.value
}

data "aws_vpc_security_group_rule" "subgraph" {
  for_each               = toset(data.aws_vpc_security_group_rules.subgraph.ids)
  security_group_rule_id = each.value
}

// The LB is an Application Load Balancer
check "alb" {
  assert {
    condition     = data.aws_alb.subgraph.load_balancer_type == "application"
    error_message = "LB ${data.aws_alb.subgraph.name} is not an application load balancer"
  }
}

// The ALB is internal
check "internal" {
  assert {
    condition     = data.aws_alb.subgraph.internal == true
    error_message = "ALB ${data.aws_alb.subgraph.name} is not internal"
  }
}

// The ALB has an HTTP listener on the right port
check "listener_port" {
  assert {
    condition     = data.aws_alb_listener.subgraph.port == var.alb_port && data.aws_alb_listener.subgraph.protocol == "HTTP"
    error_message = "ALB Listener associated with ${data.aws_alb.subgraph.name} does not listen on port ${var.alb_port} on the HTTP protocol"
  }
}

// The ALB has a security group that allows ingress traffic from the AWS VPC Lattice prefix list
check "security_group_ingress" {
  assert {
    condition = contains(
      [for rule in data.aws_vpc_security_group_rule.subgraph : [rule.prefix_list_id, rule.from_port, rule.is_egress]],
      [data.aws_ec2_managed_prefix_list.lattice_ipv4.id, var.alb_port, false]
      ) || contains(
      [for rule in data.aws_vpc_security_group_rule.subgraph : [rule.prefix_list_id, rule.from_port, rule.is_egress]],
      [data.aws_ec2_managed_prefix_list.lattice_ipv6.id, var.alb_port, false]
    )
    error_message = "ALB ${data.aws_alb.subgraph.name} does not allow traffic from the Lattice managed prefix list"
  }
}

// The ALB is in the right VPC
check "subnet_vpc" {
  assert {
    condition     = alltrue([for subnet in data.aws_subnet.subgraph : subnet.vpc_id == var.vpc_id])
    error_message = "ALB ${data.aws_alb.subgraph.name} is not in VPC ${var.vpc_id}"
  }
}
