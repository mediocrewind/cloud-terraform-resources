// ---------------------------------------------------------------------------------------------------------
// module call - aws vpc
module "vpc_base" {
  source = "./modules/vpc-base"
  resource_name      = var.resource_name
  region             = var.region
  instance_tenancy   = var.instance_tenancy
  cidr_block         = var.cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  multiple_nat       = var.multiple_nat
  tags               = var.resource_tags
}

// ---------------------------------------------------------------------------------------------------------
// module call - aws vpc nat ec2
module "vpc_nat_ec2" {
  count  = var.nat_ec2 ? 1 : 0
  source = "./modules/vpc-nat-ec2"
  resource_name           = var.resource_name
  vpc_id                  = module.vpc_base.vpc_id_output
  vpc_cidr_block          = module.vpc_base.vpc_cidr_block_output
  private_subnets         = var.private_subnets
  multiple_nat            = var.multiple_nat
  nat_ec2_subnet_ids      = module.vpc_base.vpc_pub_sub_output
  vpc_private_route_table = module.vpc_base.vpc_pri_rt_output
  tags                    = var.resource_tags
  depends_on = [
    module.vpc_base
  ]
}

// ---------------------------------------------------------------------------------------------------------
// module call - aws vpc nat gateway
module "vpc_nat_gateway" {
  count  = var.nat_gateway ? 1 : 0
  source = "./modules/vpc-nat-gw"
  resource_name =         var.resource_name
  vpc_id                  = module.vpc_base.vpc_id_output
  private_subnets         = var.private_subnets
  vpc_ngw_subnet_ids      = module.vpc_base.vpc_pub_sub_output
  vpc_private_route_table = module.vpc_base.vpc_pri_rt_output
  multiple_nat            = var.multiple_nat
  tags                    = var.resource_tags
  depends_on = [
    module.vpc_base
  ]
}
