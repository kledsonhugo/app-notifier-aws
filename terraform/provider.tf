# PROVIDER
terraform {

  required_version = "~> 1.4.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-hike1"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock-hike"
    region         = "us-east-1"
  }

}

# provider "aws" {
#   region                   = "us-east-1"
#   shared_config_files      = ["./.aws/config"]
#   shared_credentials_files = ["./.aws/credentials"]
#   profile                  = "fiap"
# }
