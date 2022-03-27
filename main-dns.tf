# You can remove this file if you don't want to use DNS Names
provider "aws" {
  alias  = "dnsupdate"
  region = var.dns.dnsupdate_region
  assume_role {
    role_arn = var.dns.dnsupdate_rolearn
  }
}

locals {
  # to avoid the error message 

}
module "dns_records" {
  count  = var.dns != null ? 1 : 0
  source = "./modules/dnsrecord"
  providers = {
    aws = aws.dnsupdate
  }

  route53_zoneid = var.dns.route53_zoneid

  a_records = [{
    name    = "test-ipv4"
    records = ["192.168.0.1"]
  }]
}

output "dns_records" {
  #  sensitive = true
  value = module.dns_records
}
