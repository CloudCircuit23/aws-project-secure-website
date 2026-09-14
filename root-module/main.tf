provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket       = "terraform-bucket-8673483"
    key          = "backend/cloudtrail.security/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}

module "secure-aws-website" {
  source = "../secure-aws-website"
}