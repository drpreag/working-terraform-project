# basic terraform project settings

terraform {
  required_version = ">=1.2.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
  }
  backend "s3" {
    bucket = "imosoft-terraform-state-bucket"
    region = "eu-west-1"
    key    = "wtf/env-prod.tfstate"
  }
}

provider "aws" {
  region  = var.aws-region
  profile = "default"
  default_tags {
    tags = {
      Environment = "${var.environment}"
      Owner       = "DrPreAG"
      Creator     = "wtf"
      Project     = "wtf-terraform-project"
      Vpc         = "${var.vpc-name}-${var.environment}"
    }
  }
}
