// ---------------------------------------------------------------------------------------------------------
// data dependencies
data "aws_availability_zones" "availability_zones" {
  state = "available"
}

// ---------------------------------------------------------------------------------------------------------
// local variables
locals {
  availability_zones = slice(
    data.aws_availability_zones.availability_zones.names, 0, length(var.public_subnets)
  )
}

// ---------------------------------------------------------------------------------------------------------
// vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "${var.resource_name}-vpc"
    },
    var.tags
  )
}

// ---------------------------------------------------------------------------------------------------------
// vpc internet gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.resource_name}-igw"
    },
    var.tags
  )
  depends_on = [
    aws_vpc.vpc
  ]
}

// ---------------------------------------------------------------------------------------------------------
// vpc public-subnets
resource "aws_subnet" "vpc_pub_sub" {
  count                   = length(var.public_subnets)
  vpc_id                  = element(aws_vpc.vpc.*.id, count.index)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge (
    {
      Name = "${var.resource_name}-pub-sub-${element(local.availability_zones, count.index)}"
    },
    var.tags
  )
  depends_on = [
    aws_vpc.vpc
  ]
}

// ---------------------------------------------------------------------------------------------------------
// vpc private-subnets
resource "aws_subnet" "vpc_pri_sub" {
  count                   = length(var.private_subnets)
  vpc_id                  = element(aws_vpc.vpc.*.id, count.index)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    {
      Name = "${var.resource_name}-pri-sub-${element(local.availability_zones, count.index)}"
    },
    var.tags
  )
  depends_on = [
    aws_vpc.vpc
  ]
}

// ---------------------------------------------------------------------------------------------------------
// vpc public route table
resource "aws_route_table" "vpc_pub_rt" {
  vpc_id = aws_vpc.vpc.id
  // public subnets connection to internet via internet-gateway
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = merge(
    {
      Name = "${var.resource_name}-public-route"
    },
    var.tags
  )
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.vpc_igw,
    aws_subnet.vpc_pub_sub,
    aws_subnet.vpc_pri_sub
  ] 
}

// ---------------------------------------------------------------------------------------------------------
// vpc public route subnet association
resource "aws_route_table_association" "vpc_pub_rt_sub_asc" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.vpc_pub_sub[*].id, count.index)
  route_table_id = element(aws_route_table.vpc_pub_rt[*].id, count.index)
  depends_on = [
    aws_route_table.vpc_pub_rt
  ]   
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc private route table
resource "aws_route_table" "vpc_pri_rt" {
  count  = var.multiple_nat != true ? 1 : length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.resource_name}-private-route"
    },
    var.tags
  )
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.vpc_pri_sub
  ] 
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc private route subnet association
resource "aws_route_table_association" "vpc_pri_rt_sub_asc" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.vpc_pri_sub[*].id, count.index)
  route_table_id = element(aws_route_table.vpc_pri_rt[*].id, count.index)
}
