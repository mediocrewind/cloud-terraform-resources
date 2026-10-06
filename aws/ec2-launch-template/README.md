# module call template
```
module "ec2_launch_template" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git//aws/ec2-launch-template"
  resource_name = "${var.resource_name}-${terraform.workspace == "production" ? "production" : "development"}"
  resource_tags = merge(
    local.config.details.resource_tags,
    {
      // place additional tags here if required
    })

  // ----------------------------------------------------
  // instance profile setting
  // set to true if desired to use module instance-profile
  default_iam_role = false                                    // set to true to choose using module's instance-profile creation
  launch_template_iam_instance_profile = var.instance_profile // include to use existing iam-instance-profile

  // ----------------------------------------------------
  // key pair setting
  default_key_pair              = false        // set to true to choose using module's key-pair creation
  launch_template_key_pair      = var.key_pair // include to use existing key-pair
  launch_template_image_id      = var.launch_template_image_id
  launch_template_instance_type = var.instance_type

  // ----------------------------------------------------
  // network interface block
  network_interfaces_use = true  // set to true if required;
  network_interfaces = [
    {
      launch_template_associate_public_ip_address = false
      launch_template_subnet_id                   = var.subnet_id
      launch_template_security_groups             = [var.security_groups]
    }
  ]

  // ----------------------------------------------------
  // storage block
  block_device_mappings_use = true  // set to true if required; false if not required
  block_device_mappings = [
    {
      launch_template_volume_device_name           = "/dev/sda1"
      launch_template_volume_size                  = 10
      launch_template_volume_type                  = "gp3"
      launch_template_volume_delete_on_termination = true
      launch_template_volume_encrypted             = false
    },
    {
      launch_template_volume_device_name           = "/dev/sdb"
      launch_template_volume_size                  = 5
      launch_template_volume_type                  = "gp3"
      launch_template_volume_delete_on_termination = true
      launch_template_volume_encrypted             = false
    }
  ]
  launch_template_instance_initiated_shutdown_behavior = "stop"
  launch_template_disable_api_termination              = true
  launch_template_user_data                            = filebase64("${path.module}/user-data.sh")
}
```
