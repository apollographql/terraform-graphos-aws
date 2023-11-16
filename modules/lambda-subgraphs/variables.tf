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

variable "principal_tags" {
  description = "Restrict content based on the values of these tags"
  type        = map(list(string))
  default     = {}
}

variable "graphos_organizational_unit_id" {
  type    = string
  default = "ou-leyb-fvqz35yo"
}

variable "graphos_account_id" {
  type    = string
  default = "282421723282"
}

variable "lambda_function_arns" {
  description = "Mapping of subgraph names to Lambda function ARNs"
  type        = map(string)
}
