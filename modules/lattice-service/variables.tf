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

variable "default_target_group" {
  description = "Default target group for the Lattice service (defaults to 404)"
  type        = string
  default     = ""
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
