# PROVIDER
terraform {

  required_version = "~> 1.3.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34"
    }
  }

  backend "s3" {
    bucket         = "tf-state-notifier-bucket"
    key            = "terraform.tfstate"
    dynamodb_table = "tf-state-notifier-table"
  }

}

provider "aws" {
  region  = "us-east-1"
}