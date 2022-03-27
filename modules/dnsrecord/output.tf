output "a_records" {
  #  sensitive = true
  value = aws_route53_record.a_records
}

output "aaaa_records" {
  #  sensitive = true
  value = aws_route53_record.aaaa_records
}

output "cname_records" {
  #  sensitive = true
  value = aws_route53_record.cname_records
}
