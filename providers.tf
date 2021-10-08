terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  #Backend for our tfstate file - Note that this bucket has been created manually in <Region>
  backend "s3" {
    bucket = "<ORG>-<APPLICATION>-backend-statefile-<REGION>"
    key    = "prod/terraform.tfstate"
    region = "<REGION>"
  }
}


#Set a Default region to work in
provider "aws" {
  region = "us-east-1"
}

#Provider for the SSL certificate - this must be created in us-east-1 in order for cloudfront to use them
provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

