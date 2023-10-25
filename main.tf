terraform {
  backend "s3" {
    bucket                  = "dc11-bdphu-devopstraining-apache2log"
    key                     = "product/terraform-project"
    region                  = "ap-southeast-2"
    shared_credentials_file = "~/.aws/credentials"
    dynamodb_table          = "terraform-state-lock-dynamo"
  }
  required_providers {
    aws = {
      source  = "local/hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "default"
}
