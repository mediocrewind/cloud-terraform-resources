// ---------------------------------------------------------------------------------------------------------
// codebuild project
resource "aws_codebuild_project" "this" {
  name        = var.resource_name
  description = var.description
  tags        = var.resource_tags
  source {
    type            = var.source_type
    location        = var.source_location
    git_clone_depth = var.source_clone_depth != "" ? var.source_clone_depth : null
    git_submodules_config {
      fetch_submodules = var.source_fetch_submodules != "" ? var.source_fetch_submodules : null
    }
    buildspec = var.source_buildspec
  }
  source_version = var.source_version != "" ? var.source_version : null
  environment {
    type                        = var.environment_type
    compute_type                = var.environment_compute_type
    image                       = var.environment_image
    image_pull_credentials_type = var.environment_image_pull_credential_type
    privileged_mode             = var.environment_privileged_mode
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }
  service_role   = var.service_role
  build_timeout  = var.build_timeout
  queued_timeout = var.queued_timeout
  dynamic "vpc_config" {
    for_each = var.vpc_config_use ?  var.vpc_config : []
    content {
      vpc_id             = vpc_config.value.vpc_config_vpc_id
      subnets            = vpc_config.value.vpc_subnets
      security_group_ids = vpc_config.value.vpc_security_group_ids
    }
  }
  artifacts {
    type           = var.artifacts_type
    location       = var.artifacts_type == "S3" ? var.artifact_location : var.artifact_location
    path           = var.artifacts_type == "S3" ? var.artifact_path : var.artifact_path
    namespace_type = var.artifacts_type == "S3" ? var.namespace_type : var.namespace_type 
  }
  dynamic logs_config {
    for_each = var.log_type == "cloudwatch" ? [1] : var.log_type == "s3" ? [1] : []
    content {
      cloudwatch_logs {
        status      = var.log_type == "cloudwatch" ? "ENABLED" : "DISABLED"
        group_name  = "/aws/codebuild/${var.resource_name}"
        stream_name = "/aws/codebuild/${var.resource_name}"
      }
      s3_logs {
        status   = var.log_type == "s3" ? "ENABLED" : "DISABLED"
        location = var.log_type == "s3" ? "${var.log_s3_bucket}/${var.resource_name}" : null
      }      
    }
  }
}
