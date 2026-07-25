terraform {
  required_version = ">1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "ft-state-984140674362"
    region       = "eu-central-1"
    key          = "network/network.tfstate"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}
