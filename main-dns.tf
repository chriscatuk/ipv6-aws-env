# ======================================
#          Remove this file
#    if you don't have var.dns setup
# ======================================


# You can remove this file if you don't want to use DNS Names
provider "aws" {
  alias  = "dnsupdate"
  region = var.dns.dnsupdate_region
  assume_role {
    role_arn = var.dns.dnsupdate_rolearn
  }
  default_tags {
    tags = var.tags
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
    records = ["192.168.0.1", "192.168.0.2"]
  }]
  aaaa_records = [{
    name    = "test-ipv6"
    records = ["2001:0db8:8888:7777::1", "2001:0db8:8888:7777::2"]
  }]
  cname_records = [{
    name    = "test-cname"
    records = ["test-ipv6.${var.dns.route53_domain}"]
    }, {
    name    = "test4-cname"
    records = ["test-ipv4.${var.dns.route53_domain}"]
  }]
}

# output "dns_records" {
#   #  sensitive = true
#   value = module.dns_records
# }
