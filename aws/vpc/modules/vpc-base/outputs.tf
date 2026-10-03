// ---------------------------------------------------------------------------------------------------------
// vpc
output "vpc_id_output" {
  value = aws_vpc.vpc.id
}
output "vpc_region" {
  value = var.region
}
output "vpc_cidr_block_output" {
  value = aws_vpc.vpc.cidr_block
}
output "vpc_availability_zones_output" {
  value = local.availability_zones
}

// ---------------------------------------------------------------------------------------------------------
// vpc internet gateway
output "vpc_igw_output" {
  value = aws_internet_gateway.vpc_igw.id
}

// ---------------------------------------------------------------------------------------------------------
// vpc public-subnets
output "vpc_pub_sub_output" {
  value = aws_subnet.vpc_pub_sub[*].id
}

// ---------------------------------------------------------------------------------------------------------
// vpc private-subnets
output "vpc_pri_sub_output" {
  value = aws_subnet.vpc_pri_sub[*].id
}

// ---------------------------------------------------------------------------------------------------------
// vpc public route table
output "vpc_pub_rt_output" {
  value = aws_route_table.vpc_pub_rt.id
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc private route table
output "vpc_pri_rt_output" {
  value = aws_route_table.vpc_pri_rt[*].id
}
