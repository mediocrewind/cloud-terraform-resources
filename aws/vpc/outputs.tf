output "vpc_base" {
    value = module.vpc_base
}
output "vpc_base_nat" {
  value = var.nat_ec2 ? module.vpc_nat_ec2[0] : var.nat_gateway ? module.vpc_nat_gateway[0] : ""
}