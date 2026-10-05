# module call sample template
module "aws_security_group" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git//aws/vpc-security-group"
  resource_name = "resource-security-group-name"
  resource_tags = merge(
    var.resource_tags,
    {
      product = my-product
    })
  vpc_id = vpc-id
  ingress_rules = [
    {
      security_group_description = "accept http traffic from internet"
      security_group_protocol    = "tcp"
      security_group_from_port   = 80
      security_group_to_port     = 80
      security_group_cidr_blocks = ["0.0.0.0/0"]
    },
    {
      security_group_description = "accept https traffic from internet"
      security_group_protocol    = "tcp"
      security_group_from_port   = 443
      security_group_to_port     = 443
      security_group_cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
    security_group_description = "allow all outgoing traffic"
    security_group_protocol    = "all"
    security_group_from_port   = 0
    security_group_to_port     = 0
    security_group_cidr_blocks = ["0.0.0.0/0"]
    }  
  ]
}
output "aws_security_group" {
  value = module.aws_security_group
}
