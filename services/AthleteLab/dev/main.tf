# development environment
terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "hs-athletelab-tfstate"
    key = "hs-athletelab.dev/hs-athletelab.dev.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = var.aws_default_region
  version = "~> 3.2.0"
}
