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

variable "graphos_organizational_unit_id" {
  type    = string
  default = "ou-leyb-fvqz35yo"
}

variable "graphos_account_id" {
  type    = string
  default = "282421723282"
}

variable "vpc_id" {
  description = "ID of the VPC where the subgraphs run"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id must be a valid VPC ID, starting with \"vpc-\"."
  }
}

variable "principal_tags" {
  description = "Restrict content based on the values of these tags"
  type        = map(list(string))
  default     = {}
}

variable "alb_arn" {
  description = "ARN of the load balancer"
  type        = string
}

variable "alb_port" {
  description = "Port for the ALB listener"
  type        = number
  default     = 80
}
