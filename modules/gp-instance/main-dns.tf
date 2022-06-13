# ==================== 
#       DNS NAME       
# ==================== 

# You can remove this file if you don't want to use DNS Names
terraform {
  required_version = ">=1.2"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.8"
      configuration_aliases = [aws.dnsupdate]
    }
  }
}


resource "aws_route53_record" "servername_ipv4" {
  count    = var.public_ipv4 ? 1 : 0
  provider = aws.dnsupdate
  zone_id  = var.route53_zoneID
  name     = "${var.hostname}."
  type     = "A"
  ttl      = "60"
  records  = [aws_eip.ip[0].public_ip]
}

resource "aws_route53_record" "servername_ipv4_internal" {
  count    = (var.public_ipv4 || !var.ipv6) ? 1 : 0
  provider = aws.dnsupdate
  zone_id  = var.route53_zoneID
  name     = "internal-${var.hostname}."
  type     = "A"
  ttl      = "60"
  records  = [aws_instance.instance.private_ip]
}

resource "aws_route53_record" "servername_ipv6" {
  count    = var.ipv6 ? 1 : 0
  provider = aws.dnsupdate
  zone_id  = var.route53_zoneID
  name     = "${var.hostname}."
  type     = "AAAA"
  ttl      = "60"
  records  = aws_instance.instance.ipv6_addresses
}

