terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  // setup the AWS provider
}

module "graphos_aws" {
  source = "../terraform-graphos-aws"

  alb_subgraphs = {
    "some-subgraph" = {
      alb_arn = "arn:aws:elasticloadbalancing:eu-west-1:123456789012:loadbalancer/app/some-app-name/1234567890abcdef"
      vpc_id  = "vpc-1234567890abcdef0"
    }
  }
}

output "resource_share_arn" {
  value = module.graphos_aws.resource_share_arn
}
