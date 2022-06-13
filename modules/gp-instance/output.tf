output "instance" {
  value = aws_instance.instance
}

output "private_ip" {
  value = var.public_ipv4 ? aws_instance.instance.private_ip : null
}

output "public_ipv4" {
  value = var.public_ipv4 ? aws_eip.ip[0].public_ip : null
}

output "id" {
  value = aws_instance.instance.id
}

output "ipv6_address" {
  value = aws_instance.instance.ipv6_addresses
}

output "hostname" {
  value = var.hostname
}

output "internal_hostname" {
  value = "internal-${var.hostname}"
}

output "primary_network_interface_id" {
  value = aws_instance.instance.primary_network_interface_id
}
