terraform {
  backend "s3" {
    bucket         = "terraform-state-storage-646364352403"
    dynamodb_table = "terraform-state-lock-646364352403"
    key            = "hello-world-api-dev/app.tfstate"
    region         = "us-west-2"
  }
}

provider "aws" {
  version = "~> 2.42"
  region  = "us-west-2"
}

variable "image_tag" {
  type = string
}

module "app" {
  source    = "../../modules/app/"
  env       = "dev"
  image_tag = var.image_tag
}

output "url" {
  value = module.app.url
}
