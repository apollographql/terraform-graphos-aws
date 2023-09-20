variable "prefix" {
  description = "Prefix for resources created in this module"
  type        = string
  default     = "graphos"
}

variable "vpc_id" {
  description = "ID of the VPC where the subgraphs run"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets where the internal ALB will run"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs used by the internal ALB"
  type        = list(string)
}

variable "alb_target_group_arns" {
  description = "Mapping of subgraph names to ALB target group ARNs"
  type        = map(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on the internal ALB"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for AWS resources created in this module"
  type        = map(string)
  default     = {}
}
