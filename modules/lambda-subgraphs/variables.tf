variable "prefix" {
  description = "Prefix for resources created in this module"
  type        = string
  default     = "graphos"
}

variable "lambda_function_arns" {
  description = "Mapping of subgraph names to Lambda function ARNs"
  type        = map(string)
}

variable "tags" {
  description = "Tags for AWS resources created in this module"
  type        = map(string)
  default     = {}
}
