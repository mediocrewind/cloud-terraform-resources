// ---------------------------------------------------------------------------------------------------------
// aws latest ami (amazonlinux2)
output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

// ---------------------------------------------------------------------------------------------------------
// aws ec2 nat instance role
output "vpc_nat_ec2_instance_role_arn_output" {
  value = aws_iam_role.vpc_nat_ec2_instance_role.arn
}

// ---------------------------------------------------------------------------------------------------------
// aws ec2 nat instance-profile
output "vpc_nat_ec2_instance_profile_arn_output" {
  value = aws_iam_instance_profile.vpc_nat_ec2_instance_profile.arn
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc ec2-nat security-group
output "vpc_nat_ec2_pass_through_sg_output" {
  value = aws_security_group.vpc_nat_ec2_pass_through_sg.id
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc ec2-nat security-group
output "vpc_nat_ec2_sg_output" {
  value = aws_security_group.vpc_nat_ec2_sg.id
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc nat-ec2 key-pair
output "vpc_nat_ec2_key_pair_output" {
  value = aws_key_pair.vpc_nat_ec2_key_pair.key_name
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc nat-ec2
output "vpc_nat_ec2_eni_output" {
  value = aws_instance.vpc_nat_ec2[*].primary_network_interface_id
}
