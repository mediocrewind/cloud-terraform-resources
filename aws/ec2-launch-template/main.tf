// ---------------------------------------------------------------------------------------------------------
// ec2 launch-template instance role
resource "aws_iam_role" "this" {
  count = var.default_iam_role ? 1 : 0
  name  = "${var.resource_name}-ec2-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ]
  })
  tags = merge(
    {
      Name = "${var.resource_name}-ec2-instance-role"
    },
    var.resource_tags
  )
}
output "ec2_launch_template_iam_role_output" {
  value = try(aws_iam_role.this[0].name, null)
}
// aws ec2 iam-policy attached policies
resource "aws_iam_role_policy_attachment" "vpc_nat_ec2_instance_role_AmazonSSMManagedInstanceCore" {
  count      = var.default_iam_role ? 1 : 0 
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"   
}

// ---------------------------------------------------------------------------------------------------------
// aws ec2 nat instance-profile
resource "aws_iam_instance_profile" "this" {
  count = var.default_iam_role ? 1 : 0  
  name  = "${var.resource_name}-ec2-instance-role"
  role  = aws_iam_role.this[0].name
  tags  = merge(
    {
      Name = "${var.resource_name}-ec2-instance-role"
    },
    var.resource_tags
  )
}

// ---------------------------------------------------------------------------------------------------------
//security-group
resource "aws_security_group" "this" {
  count = var.default_security_group ? 1 : 0 
  name   = "${var.resource_name}-sg"  
  vpc_id = var.vpc_id
  egress {
    protocol    = "all"
    from_port   = 0
    to_port     = 0    
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      Name = "${var.resource_name}-sg"
    },
    var.resource_tags
  )
}
output "ec2_launch_template_sg_output" {
  value = try(aws_security_group.this[0].id, null)
}

// ---------------------------------------------------------------------------------------------------------
// ec2 launch-template
resource "tls_private_key" "this" {
  count     = length(var.launch_template_key_name) > 0 ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "this" {
  count      = length(var.launch_template_key_name) > 0 ? 0 : 1
  key_name   = "${var.resource_name}-kp"
  public_key = tls_private_key.this[count.index].public_key_openssh
}
resource "aws_launch_template" "this" {
  name          = "${var.resource_name}-lt"
  image_id      = var.launch_template_image_id != "" ? var.launch_template_image_id : null
  instance_type = var.launch_template_instance_type != "" ? var.launch_template_instance_type : null
  key_name      = try(var.launch_template_key_name, aws_key_pair.this[0].key_name)
  dynamic "network_interfaces" {
    for_each = var.network_interfaces_use ? var.network_interfaces : []
    content {
      device_index                = network_interfaces.key
      associate_public_ip_address = network_interfaces.value.launch_template_associate_public_ip_address
      subnet_id                   = network_interfaces.value.launch_template_subnet_id != "" ? network_interfaces.value.launch_template_subnet_id : null
      security_groups             = try(network_interfaces.value.launch_template_security_groups, aws_security_group.this[0].id)
    }
  }
  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings_use ?  var.block_device_mappings : []
    content {
      device_name = block_device_mappings.value.launch_template_volume_device_name
      ebs {
        volume_size           = block_device_mappings.value.launch_template_volume_size
        volume_type           = block_device_mappings.value.launch_template_volume_type 
        delete_on_termination = block_device_mappings.value.launch_template_volume_delete_on_termination
        encrypted             = block_device_mappings.value.launch_template_volume_encrypted
      }
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        Name = var.resource_name
      },
      var.resource_tags
    )
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      {
        Name = var.resource_name
      },
      var.resource_tags
    )
  }
  iam_instance_profile {
    arn = try(var.launch_template_iam_instance_profile, aws_iam_instance_profile.this[0])
  }
  instance_initiated_shutdown_behavior = var.launch_template_instance_initiated_shutdown_behavior
  disable_api_termination              = var.launch_template_disable_api_termination
  user_data                            = var.launch_template_user_data
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
