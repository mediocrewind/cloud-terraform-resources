# module call template
```
module "ec2_launch_template" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git//aws/ec2-launch-template"
  resource_name = "${local.config.details.resource_name}-${terraform.workspace == "production" ? "prd" : "env"}"
  resource_tags = merge(
    local.config.details.resource_tags,
    {
      // place additional tags here if required
    })
  default_iam_role              = true
  //default_security_group        = true
  //vpc_id                        = data.terraform_remote_state.network.outputs.vpc_base.vpc_base.vpc_id_output
  launch_template_image_id      = ""
  launch_template_instance_type = ""
  launch_template_key_name      = "" # set value if required; keep blank if you want module to create key-pair
  // network interface block
  network_interfaces_use = true # set to true if required; false if not required
  network_interfaces = [
    {
      launch_template_associate_public_ip_address = false
      launch_template_subnet_id                   = ""
      launch_template_security_groups             = [module.ec2_launch_template_sg.vpc_security_group_output]
    }
  ]
  // storage block
  block_device_mappings_use = true # set to true if required; false if not required
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
  launch_template_iam_instance_profile                 = ""
  //launch_template_instance_initiated_shutdown_behavior = ""
  //launch_template_disable_api_termination              = ""
  launch_template_user_data                            = filebase64("${path.module}/user-data.sh")
}
```
