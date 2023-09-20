variable "prefix" {
  description = "Prefix for resources created in this module"
  type        = string
  default     = "graphos"
}

variable "vpc_id" {
  description = "ID of the VPC where the subgraphs run"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id must be a valid VPC ID, starting with \"vpc-\"."
  }
}

variable "subnet_ids" {
  description = "IDs of the subnets where the internal ALB will run"
  type        = list(string)
  validation {
    condition     = length(subnet_ids) > 0
    error_message = "subnet_ids must contain at least 1 subnet ID."
  }
}

variable "security_group_ids" {
  description = "Security group IDs used by the internal ALB"
  type        = list(string)
  validation {
    condition     = length(security_group_ids) > 0
    error_message = "security_group_ids must contain at least 1 security group ID."
  }
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
