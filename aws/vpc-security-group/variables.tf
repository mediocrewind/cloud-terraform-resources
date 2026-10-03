variable "resource_name" {
  type    = string
  default = "resource-name"
}
variable "resource_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}
variable "ingress_rules" {
  default = []
  type = list(object({
    security_group_description     = string
    security_group_protocol        = string
    security_group_from_port       = number
    security_group_to_port         = number
    security_group_self            = optional(bool, false)
    security_group_cidr_blocks     = optional(list(string), [])
    security_group_security_groups = optional(list(string), [])
  }))
}
variable "egress_rules" {
  default = []
  type = list(object({
    security_group_description     = string
    security_group_protocol        = string
    security_group_from_port       = number
    security_group_to_port         = number
    security_group_self            = optional(bool, false)
    security_group_cidr_blocks     = optional(list(string), [])
    security_group_security_groups = optional(list(string), [])
  }))
}
