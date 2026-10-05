output "ec2_launch_template_iam_role_output" {
  value = try(aws_iam_role.this[0].name, null)
}

output "ec2_launch_template_sg_output" {
  value = try(aws_security_group.this[0].id, null)
}

output "ec2_launch_template_id_output" {
  value = aws_launch_template.this.id
}

output "ec2_launch_template_arn_output" {
  value = aws_launch_template.this.arn
}

output "ec2_launch_template_name_output" {
  value = aws_launch_template.this.name
}
