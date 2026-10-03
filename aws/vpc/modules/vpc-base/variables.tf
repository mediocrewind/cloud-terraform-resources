variable "resource_name" {}
variable "tags" {
  default = {}
  type    = map(string)
}
variable "region" {}
variable "instance_tenancy" {}
variable "cidr_block" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "multiple_nat" {}
