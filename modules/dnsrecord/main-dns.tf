# =====================
#      DNS Record  
# =====================

resource "aws_route53_record" "a_records" {
  for_each = { for record in var.a_records : record.name => record }
  zone_id  = var.route53_zoneid
  name     = each.value.name
  type     = "A"
  ttl      = var.ttl
  records  = each.value.records
}

resource "aws_route53_record" "aaaa_records" {
  for_each = { for record in var.aaaa_records : record.name => record }
  zone_id  = var.route53_zoneid
  name     = each.value.name
  type     = "AAAA"
  ttl      = var.ttl
  records  = each.value.records
}


resource "aws_route53_record" "cname_records" {
  for_each = { for record in var.cname_records : record.name => record }
  zone_id  = var.route53_zoneid
  name     = each.value.name
  type     = "CNAME"
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
