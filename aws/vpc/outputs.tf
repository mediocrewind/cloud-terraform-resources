output "vpc_base" {
    value = module.vpc_base
}
output "vpc_base_nat" {
  value = var.config_base.network.nat_setup.nat_ec2 ? module.vpc_nat_ec2[0] : module.vpc_nat_gateway[0]
}