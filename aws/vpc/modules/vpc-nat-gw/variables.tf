variable "resource_name" {}
variable "tags" {
  default = {}
  type    = map(string)
}
variable "vpc_id" {}
variable "private_subnets" {}
variable "vpc_ngw_subnet_ids" {}
variable "vpc_private_route_table" {}
variable "multiple_nat" {}