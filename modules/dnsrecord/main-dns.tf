# =====================
#      DNS Record  
# =====================

resource "aws_route53_record" "a_records" {
  for_each = { for record in var.a_records : record.name => record }
  provider = aws.dnsupdate
  zone_id  = var.route53_zoneid
  name     = each.value.name
  type     = "A"
  ttl      = var.ttl
  records  = each.value.records
}

# resource "aws_route53_record" "servername_ipv4_internal" {
#   count    = var.enabled ? 1 : 0
#   provider = aws.dnsupdate
#   zone_id  = var.route53_zoneID
#   name     = "internal-${var.hostname}."
#   type     = "A"
#   ttl      = "60"
#   records  = [aws_instance.instance[0].private_ip]
# }

# resource "aws_route53_record" "servername_ipv6" {
#   count    = var.enabled ? 1 : 0
#   provider = aws.dnsupdate
#   zone_id  = var.route53_zoneID
#   name     = "${var.hostname}."
#   type     = "AAAA"
#   ttl      = "60"
#   records  = aws_instance.instance[0].ipv6_addresses
# }
