output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "private_subnets_ipv4only" {
  value = aws_subnet.private_subnets_ipv4only
}

output "private_subnets_ipv6only" {
  value = aws_subnet.private_subnets_ipv6only
}
