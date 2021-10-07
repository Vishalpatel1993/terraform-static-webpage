terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  #Backend for our tfstate file - Note that this bucket has been created manually in <Region>
  backend "s3" {
    bucket = "vish-terraform-test-oct2021"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}


#Set a Default region to work in
provider "aws" {
  region = "us-east-1"
}

#Provider for the SSL certificate - this must bbe created in is-east-1 in order for cloudfront to use them
provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

