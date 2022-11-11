provider "aws" {
  region = var.region
}

provider github { }

terraform {
  required_version  = ">= 1.0.0"
  backend "s3" {
    bucket          = "remote-state-us-east-1"
    key             = "github-actions/terraform.tfstate"
    region          = "us-east-1"
    encrypt         = true
  }
}