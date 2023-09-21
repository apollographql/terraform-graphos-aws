# Apollo GraphOS Cloud Private Subgraphs Module

This Terraform module helps you create the necessary resources for sharing your private subgraphs with Apollo GraphOS Cloud:

1. AWS VPC Lattice Service containing your subgraphs and set up with the recommended security configuration
2. AWS RAM Resource Share with an association with Apollo GraphOS Cloud

## Usage

```
module "graphos_aws" {
  source = "github.com/apollographql/terraform-graphos-aws"

  alb_subgraphs = {
    "some-subgraph" = {
      alb_arn = "arn:aws:elasticloadbalancing:eu-west-1:123456789012:loadbalancer/app/some-app-name/1234567890abcdef"
      vpc_id  = "vpc-1234567890abcdef0"
    }
  }

  lambda_subgraphs = {
    "a-lambda-subgraph" = {
      lambda_function_arn = "arn:aws:lambda:eu-west-1:012346789012:function:test-function"
    }
  }
}
```