variable "prefix" {
  description = "Prefix for resources created in this module"
  type        = string
  default     = "graphos"
}

variable "tags" {
  description = "Tags for AWS resources created in this module"
  type        = map(string)
  default     = {}
}

variable "alb_subgraphs" {
  description = "Mapping of name to Application Load Balancers"
  type = map(object({
    alb_arn  = string
    vpc_id   = string
    alb_port = optional(number, 80)
  }))
}

variable "lambda_subgraphs" {
  description = "Map of subgraph name to Lambda Function ARNs"
  type = map(object({
    lambda_function_arn = string
  }))
  default = {}
}

variable "apollo_account_ids" {
  description = "Restrict traffic based on a unique identifier per account"
  type        = list(string)
  default     = []
}

variable "apollo_graph_refs" {
  description = "Restrict traffic based on Cloud Router graph variant identifiers (e.g. my-graph@my-variant)"
  type        = list(string)
  default     = []
}

variable "graphos_organizational_unit_id" {
  type    = string
  default = "ou-leyb-fvqz35yo"
}

variable "graphos_account_id" {
  type    = string
  default = "282421723282"
}
