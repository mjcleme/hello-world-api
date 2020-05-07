terraform {
  backend "s3" {
    bucket         = "terraform-state-storage-646364352403"
    dynamodb_table = "terraform-state-lock-646364352403"
    key            = "hello-world-api-dev/pipeline.tfstate"
    region         = "us-west-2"
  }
}

provider "aws" {
  version = "~> 2.42"
  region  = "us-west-2"
}

module "acs" {
  source = "github.com/byu-oit/terraform-aws-acs-info?ref=v2.1.0"
}

provider "github" {
  organization = "mjcleme"
  token        = module.acs.github_token
}

module "pipeline" {
  source                        = "../../modules/pipeline/"
  env                           = "dev"
  role_permissions_boundary_arn = module.acs.role_permissions_boundary.arn
  power_builder_role_arn        = module.acs.power_builder_role.arn
  github_token                  = module.acs.github_token
}
