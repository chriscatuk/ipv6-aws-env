# ==================== 
#       DNS NAME       
# ==================== 

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
      source                = "hashicorp/aws"
      version               = ">= 4.0"
      configuration_aliases = [aws.dnsupdate]
    }
  }
}


resource "aws_route53_record" "servername_ipv4" {
  count    = var.enabled && var.public_ip ? 1 : 0
  provider = aws.dnsupdate
  zone_id  = var.route53_zoneID
  name     = "${var.hostname}."
  type     = "A"
  ttl      = "60"
  records  = [aws_eip.ip[0].public_ip]
}

resource "aws_route53_record" "servername_ipv4_internal" {
  count    = var.enabled ? 1 : 0
  provider = aws.dnsupdate
  zone_id  = var.route53_zoneID
  name     = "internal-${var.hostname}."
  type     = "A"
  ttl      = "60"
  records  = [aws_instance.instance[0].private_ip]
}

resource "aws_route53_record" "servername_ipv6" {
  count    = var.enabled ? 1 : 0
  provider = aws.dnsupdate
  zone_id  = var.route53_zoneID
  name     = "${var.hostname}."
  type     = "AAAA"
  ttl      = "60"
  records  = aws_instance.instance[0].ipv6_addresses
}

