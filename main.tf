provider "aws" {
  region  = "us-west-2"
}

variable "AWS_BACKEND_ACCESS_KEY" {}
variable "AWS_BACKEND_SECRET_KEY" {}

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
    access_key     = var.AWS_BACKEND_ACCESS_KEY
    secret_key     = var.AWS_BACKEND_SECRET_KEY
    region         = "us-west-2"

    bucket         = "dynamoosejs-ci-terraform-state-storage"
    key            = "terraform.tfstate"
    encrypt        = true

    dynamodb_table = "dynamoosejs-ci-terraform-state-locks"
  }
}
