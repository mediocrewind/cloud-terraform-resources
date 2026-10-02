// ---------------------------------------------------------------------------------------------------------
// vpc nat-gateway elastic-ip address
resource "aws_eip" "vpc_ngw_eip" {
  count  = var.multiple_nat != true ? 1 : length(var.vpc_ngw_subnet_ids)
  domain = "vpc"
  // naming convention variable values
  tags = merge(
    {
      Name = "${var.resource_name}-nat-gateway"
    },
    var.tags
  )
}

// ---------------------------------------------------------------------------------------------------------
// vpc nat-gateway
resource "aws_nat_gateway" "vpc_ngw" {
  count      = var.multiple_nat != true ? 1 : length(var.vpc_ngw_subnet_ids)
  allocation_id = element(aws_eip.vpc_ngw_eip[*].id, count.index)
  subnet_id     = element(var.vpc_ngw_subnet_ids[*], count.index)
  // naming convention variable values
  tags = merge(
    {
      Name = var.resource_name
    },
    var.tags
  )
  // dependencies
  depends_on = [
    aws_eip.vpc_ngw_eip
  ]  
}

// ---------------------------------------------------------------------------------------------------------
// aws route table entry for accessing public internet from private subnets
resource "aws_route" "route_pri_rt" {
  count = var.multiple_nat != true ? 1 : length(var.private_subnets)
  route_table_id         = element(var.vpc_private_route_table[*], count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.vpc_ngw[*].id, count.index)
}


