# ======================
#         VPC
# ======================

# You can remove this file if you don't want to use DNS Names
provider "aws" {
  alias = "dnsupdate"
  assume_role {
    role_arn = var.dnsupdate_rolearn
  }
  region = var.dnsupdate_region
}

terraform {
  required_version = ">=1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
