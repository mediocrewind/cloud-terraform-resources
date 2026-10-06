# module call template
```
module "vpc" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git//aws/vpc"
  resource_name = "${var.resource_name}-${terraform.workspace == "production" ? "production" : "development"}"
  resource_tags = merge(
    local.config.details.resource_tags,
    {
      // place additional tags here if required
    })
  region           = var.region
  instance_tenancy = var.instance_tenancy
  cidr_block       = "10.10.0.0/16"
  public_subnets   = ["10.10.10.0/24", "10.10.20.0/24"]
  private_subnets  = ["10.10.30.0/24", "10.10.40.0/24"]

  // ----------------------------------------------------
  // nat setting - either use nat_ec2 or nat_gateway
  nat_ec2          = false // ec2 nat instance configuration
  nat_gateway      = true  // nat gateway configuration
  multiple_nat     = false // set to true to apply nat on each availability-zone
}
output "vpc" {
    value = module.vpc
}
```
