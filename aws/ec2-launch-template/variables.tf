variable "resource_name" {
  type    = string
  default = "resource"
}

variable "resource_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "launch_template_image_id" {
  type = string    
}

variable "launch_template_instance_type" {
  type = string
}
variable "launch_template_key_name" {}

variable "network_interfaces_use" {
  type    = bool
  default = false
}

variable "network_interfaces" {
  type = list(object({
    launch_template_associate_public_ip_address = bool
    launch_template_subnet_id                   = string
    launch_template_security_groups             = list(string)
  }))
}

variable "block_device_mappings_use" {
  type    = bool    
  default = false
}

variable "block_device_mappings" {
  type = list(object({
    launch_template_volume_device_name           = string
    launch_template_volume_size                  = number
    launch_template_volume_type                  = string
    launch_template_volume_delete_on_termination = bool
    launch_template_volume_encrypted             = bool
  }))
}

variable "launch_template_iam_instance_profile" {
  type = string
}
variable "launch_template_instance_initiated_shutdown_behavior" {}

variable "launch_template_disable_api_termination" {}

variable "launch_template_user_data" {}
