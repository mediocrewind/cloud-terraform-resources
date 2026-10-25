# module call template
```
module "codebuild" {
  source        = "git::https://github.com/mediocrewind/cloud-terraform-resources.git//aws/codebuild"
  resource_name = "${local.config.details.resource_name}-${terraform.workspace == "production" ? "production" : "development"}"
  resource_tags = merge(
    local.config.details.resource_tags,{
      // place additional tags here if required
    })
  description                            = var.description
  source_type                            = var.source_type
  source_location                        = var.source_location
  source_clone_depth                     = var.source_clone_depth
  source_fetch_submodules                = var.source_fetch_submodules
  source_buildspec                       = var.source_buildspec
  source_version                         = var.source_version
  environment_type                       = var.environment_type
  environment_compute_type               = var.environment_compute_type
  environment_image                      = var.environment_image
  environment_image_pull_credential_type = var.environment_image_pull_credential_type
  environment_privileged_mode            = var.environment_privileged_mode
  environment_variables = [
    for env in lookup(each.value, "environment_variables", []) : {
      name  = env.name
      value = env.value
      type  = env.type
    }
  ]
  service_role   = aws_iam_role.this.arn
  vpc_config_use = true   // set to true if required and set vpc_config entries;
  vpc_config     = [
    {
      vpc_config_vpc_id      = aws_vpc.vpc.id
      vpc_subnets            = [aws_subnet.vpc_subnet[0].id]
      vpc_security_group_ids = [aws_security_group.this.id]
    }
  ]
  artifacts_type     = var.artifacts_type
  artifacts_location = try(var.artifacts_location, null)
  artifacts_path     = try(var.artifacts_path, null)
  namespace_type     = try(var.namespace_type, null)
  log_type           = var.log_type
}
```
