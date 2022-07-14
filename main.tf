provider "aws" {
  region  = "us-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    region         = "us-west-2"

    bucket         = "dynamoosejs-ci-terraform-state-storage"
    key            = "terraform.tfstate"
    encrypt        = true

    dynamodb_table = "dynamoosejs-ci-terraform-state-locks"
  }
}
