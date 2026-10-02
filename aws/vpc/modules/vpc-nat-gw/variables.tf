/* ########################################################################################################## */
/* VARIABLES */

// ---------------------------------------------------------------------------------------------------------
// naming convention variable values
variable "resource_name" {}
variable "tags" {
  default = {}
  type    = map(string)
}

// ---------------------------------------------------------------------------------------------------------
// base variable values

// ---------------------------------------------------------------------------------------------------------
// vpc variable values
variable "vpc_id" {}
variable "private_subnets" {}
// vpc-nat-gw variable values
variable "vpc_ngw_subnet_ids" {}
variable "vpc_private_route_table" {}
variable "multiple_nat" {}