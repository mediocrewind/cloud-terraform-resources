# cloud-terraform-resources
cloud terraform modules
```
# use from another terraform project
module "<module-name>" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git"
  ...
}

# using specific branch
module "<module-name>" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git?ref=main"
  ...
}

# using specific tag
module "<module-name>" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git?ref=v1.0.0"
  ...
}

# using specific subdirectory
module "vpc" {
  source = "git::https://github.com/mediocrekaze/terraform-aws-example.git//aws/vpc"
  ...
}

# using specific branch and subdirectory
module "<module-name>" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git//aws/vpc?ref=main"
  ...
}

# using specific tag and subdirectory
module "<module-name>" {
  source = "git::https://github.com/mediocrewind/cloud-terraform-resources.git//aws/vpc?ref=v1.0.0"
  ...
}

```
