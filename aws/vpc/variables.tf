variable "resource_name" {
  type    = string
  default = "resource"
}

variable "resource_tags" {
  type    = map(string)
  default = {}
}

variable "region" {
  type = string
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list
}

variable "private_subnets" {
  type = list
}

variable "nat_ec2" {
  type    = bool
  default = false
}

variable "nat_gateway" {
  type    = bool
  default = false  
}

variable "multiple_nat" {
  type    = bool
  default = false
}
