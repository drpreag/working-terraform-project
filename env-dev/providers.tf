# basic terraform project settings

provider "aws" {
  region  = var.aws-region
  profile = "default"
  default_tags {
    tags = {
      Environment = "${var.environment}"
      Owner       = "DrPreAG"
      Creator     = "techworld"
      Project     = "techworld-terraform-project"
      Vpc         = "${var.vpc-name}-${var.environment}"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
  backend "s3" {
    bucket  = "imosoft-terraform-state"
    region  = "eu-west-1"
    key     = "techworld-dev.tfstate"
  }
}
