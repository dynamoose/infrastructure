provider "aws" {
  version = "~> 2.0"
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "dynamoosejs-ci-terraform-state-storage"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "dynamoosejs-ci-terraform-state-locks"
    encrypt        = true
  }
}
