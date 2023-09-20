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

variable "alb_vpc_id" {
  description = "ID of the VPC where the subgraphs run"
  type        = string
}

variable "alb_subnet_ids" {
  description = "IDs of the subnets where the internal ALB will run"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "Security group IDs used by the internal ALB"
  type        = list(string)
}

variable "alb_target_group_arns" {
  description = "Mapping of subgraph names to ALB target group ARNs"
  type        = map(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for some of the resources"
  type        = bool
  default     = true
}

variable "lambda_function_arns" {
  description = "Map of subgraph name to Lambda Function ARNs"
  type        = map(string)
}

variable "graphos_organizational_unit_id" {
  type    = string
  default = "ou-leyb-fvqz35yo"
}

variable "graphos_account_id" {
  type    = string
  default = "282421723282"
}
