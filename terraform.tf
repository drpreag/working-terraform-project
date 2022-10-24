# basic terraform project settings

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

terraform {
  required_version = ">=1.2.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
  }
  cloud {
    organization = "imo-soft"
    workspaces {
      name = "wtf"
    }
  }
}
