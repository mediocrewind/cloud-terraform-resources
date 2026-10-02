// ---------------------------------------------------------------------------------------------------------
// aws latest ami (amazonlinux2)
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

// ---------------------------------------------------------------------------------------------------------
// aws ec2 nat instance role
resource "aws_iam_role" "vpc_nat_ec2_instance_role" {
  name = "${var.resource_name}-nat-ec2-instance-role"
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
      Name = "${var.resource_name}-nat-ec2-instance-role"
    },
    var.tags
  )
}
// aws ec2 iam-policy attached policies
resource "aws_iam_role_policy_attachment" "vpc_nat_ec2_instance_role_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.vpc_nat_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"   
}

// ---------------------------------------------------------------------------------------------------------
// aws ec2 nat instance-profile
resource "aws_iam_instance_profile" "vpc_nat_ec2_instance_profile" {
  name = "${var.resource_name}-nat-ec2-instance-role"
  role = aws_iam_role.vpc_nat_ec2_instance_role.name
  tags = merge(
    {
      Name = "${var.resource_name}-nat-ec2-instance-role"
    },
    var.tags
  )
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc ec2-nat security-group
resource "aws_security_group" "vpc_nat_ec2_pass_through_sg" {
  name   = "${var.resource_name}-nat-ec2-pass-through-sg"
  vpc_id = var.vpc_id
  ingress {
    description = "default security-group ingress"
    protocol    = "icmp"
    from_port   = 8
    to_port     = 8
    self        = true
  }
  egress {
    protocol    = "all"
    from_port   = 0
    to_port     = 0    
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      Name = "${var.resource_name}-nat-ec2-pass-through-sg"
    },
    var.tags
  )
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc ec2-nat security-group
resource "aws_security_group" "vpc_nat_ec2_sg" {
  name   = "${var.resource_name}-nat-ec2-sg"
  vpc_id = var.vpc_id
  ingress {
    description = "default security-group ingress"
    protocol    = "icmp"
    from_port   = 8
    to_port     = 8
    self        = true
  }
  ingress {
    description = "allow ssh remote access rule"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.vpc_cidr_block]
  }
  ingress {
    description = "allow traffic pass through for internet connection"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    security_groups = [aws_security_group.vpc_nat_ec2_pass_through_sg.id]
  }  
  egress {
    protocol    = "all"
    from_port   = 0
    to_port     = 0    
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      Name = "${var.resource_name}-nat-ec2-sg"
    },
    var.tags
  )
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc nat-ec2 key-pair
resource "tls_private_key" "vpc_nat_ec2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "vpc_nat_ec2_key_pair" {
  key_name   = "${var.resource_name}-nat-ec2"
  public_key = tls_private_key.vpc_nat_ec2_private_key.public_key_openssh
}

// ---------------------------------------------------------------------------------------------------------
// aws vpc nat-ec2
resource "aws_instance" "vpc_nat_ec2" {
  count = var.multiple_nat != true ? 1 : length(var.private_subnets)
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t3.nano"
  key_name                    = aws_key_pair.vpc_nat_ec2_key_pair.key_name
  subnet_id                   = element(var.nat_ec2_subnet_ids.*, count.index)
  associate_public_ip_address = true
  source_dest_check           = false
  security_groups             = [aws_security_group.vpc_nat_ec2_sg.id]
  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    iops                  = 3000
    delete_on_termination = true
    throughput            = 125
    tags = merge(
      {
        Name = "${var.resource_name}-nat-ec2"
      },
      var.tags
    )
  }
  iam_instance_profile = aws_iam_instance_profile.vpc_nat_ec2_instance_profile.name
  metadata_options {
    http_tokens = "required"
  }
  user_data = <<EOF
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
repo_upgrade: none

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
sudo yum install iptables-services -y
sudo systemctl enable iptables
sudo systemctl start iptables
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/custom-ip-forwarding.conf
sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo /sbin/iptables -F FORWARD
sudo service iptables save
--//--
EOF
  tags = merge(
    {
      Name = "${var.resource_name}-nat-ec2"
    },
    var.tags
  )
  // dependencies
  depends_on = [
    aws_security_group.vpc_nat_ec2_sg,
    aws_iam_instance_profile.vpc_nat_ec2_instance_profile
  ]
}

// ---------------------------------------------------------------------------------------------------------
// aws route table entry for accessing public internet from private subnets
resource "aws_route" "route_pri_rt" {
  count = var.multiple_nat != true ? 1 : length(var.private_subnets)
  route_table_id         = element(var.vpc_private_route_table[*], count.index)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = element(aws_instance.vpc_nat_ec2[*].primary_network_interface_id, count.index)
}
