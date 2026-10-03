// ---------------------------------------------------------------------------------------------------------
//vpc security-group
resource "aws_security_group" "this" {
  name   = "${var.resource_name}-sg"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description     = length(ingress.value.security_group_description) > 0 ? ingress.value.security_group_description : null
      protocol        = ingress.value.security_group_protocol
      from_port       = ingress.value.security_group_from_port
      to_port         = ingress.value.security_group_to_port
      self            = ingress.value.security_group_self
      cidr_blocks     = ingress.value.security_group_cidr_blocks
      security_groups = ingress.value.security_group_security_groups
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description     = length(egress.value.security_group_description) > 0 ? egress.value.security_group_description : null
      protocol        = length(egress.value.security_group_protocol) > 0 ? egress.value.security_group_protocol: "-1"
      from_port       = egress.value.security_group_from_port
      to_port         = egress.value.security_group_to_port
      self            = egress.value.security_group_self
      cidr_blocks     = egress.value.security_group_cidr_blocks
      security_groups = egress.value.security_group_security_groups
    }
  }
  // naming convention variable values
  tags = merge(
    {
      Name = "${var.resource_name}-sg"
    },
    var.resource_tags
  )
}
