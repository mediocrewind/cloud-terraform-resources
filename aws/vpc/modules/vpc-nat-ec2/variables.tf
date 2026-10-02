variable "resource_name" {}
variable "tags" {
  default = {}
  type    = map(string)
}
variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "nat_ec2_subnet_ids" {}
variable "vpc_private_route_table" {}
variable "private_subnets" {}
variable "multiple_nat" {}