# =====================
#     AWS Provider       
# =====================

terraform {
  required_version = ">=1.1"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0"
    }
  }
}


# =========================================
#     Example how to call this module
# =========================================

# provider "aws" {
#   alias = "dnsupdate"
#   assume_role {
#     role_arn = var.dns.dnsupdate_rolearn
#   }
#   region = var.dns.dnsupdate_region
# }


# module "dsnrecord" {
#   source = "./modules/dnsrecord"
#   providers = {
#     aws = aws.dnsupdate
#   }
