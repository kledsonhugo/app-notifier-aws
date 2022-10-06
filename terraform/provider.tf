# PROVIDER
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-notifier-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-notifier-table"
  }

}
