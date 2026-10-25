variable "resource_name" {
  type    = string
  default = "resource"
}

variable "resource_tags" {
  type    = map(string)
  default = {}
}

variable "description" {
  type    = string
  default = null
}

variable "source_type" {
  type    = string
  default = "NO_SOURCE"
}

variable "source_location" {
  type    = string
  default = null
}

variable "source_clone_depth" {
  default = null
}

variable "source_fetch_submodules" {
  type    = bool
  default = false
}

variable "source_buildspec" {
  type    = any
  default = null
}

variable "source_version" {
  type    = string
  default = null  
}

variable "environment_type" {
  type    = string
  default = "LINUX_CONTAINER"
}

variable "environment_compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}

variable "environment_image" {
  type    = string
  default = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}

variable "environment_image_pull_credential_type" {
  type    = string
  default = "CODEBUILD"
}

variable "environment_privileged_mode" {
  type    = bool
  default = false
}

variable "environment_variables" {
  default = []
  type = list(object({
    name  = string
    value = string
    type  =  string
  }))
}

variable "service_role" {
  type = string
}

variable "build_timeout" {
  default = 60
}

variable "queued_timeout" {
  default = 480
}

variable "vpc_config_use" {
  default = false
}

variable "vpc_config" {
  default = []
  type = list(object({
    vpc_config_vpc_id      = string
    vpc_subnets            = list(string)
    vpc_security_group_ids = list(string)
  }))
}

variable "artifacts_type" {
  type    = string
  default = "NO_ARTIFACTS"
}

variable "artifacts_location" {
  type    = string
  default = null
}

variable "artifacts_path" {
  type    = string
  default = null  
}

variable "namespace_type" {
  type    = string
  default = null  
}

variable "cache_type" {
  type    = string
  default = "NO_CACHE"
}

variable "cache_location" {
  type    = string
  default = null
}

variable "cache_modes" {
  type    = list
  default = null
}

variable "cache_namespace" {
  type    = string
  default = null
}

variable "log_type" {
  type   = string
  default = null    
}

variable "log_s3_bucket" {
  type   = string
  default = null    
}
