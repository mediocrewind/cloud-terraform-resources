// ---------------------------------------------------------------------------------------------------------
// vpc nat-gateway elastic-ip address
output "vpc_ngw_eip_output" {
  value = aws_eip.vpc_ngw_eip[*].id
}

// ---------------------------------------------------------------------------------------------------------
// vpc nat-gateway
output "vpc_ngw_output" {
  value = aws_nat_gateway.vpc_ngw[*].id
}
