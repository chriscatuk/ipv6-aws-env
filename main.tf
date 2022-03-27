# ======================================
#          Backend s3 is in 
#  >>>>>>   backend.safe.tf   <<<<<<
# ======================================

terraform {
  required_version = ">=1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.regions.principal

  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.regions.secondary

  default_tags {
    tags = var.tags
  }
}
