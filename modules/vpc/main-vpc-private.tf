# =====================
#     NAT GATEWAY   
# =====================
resource "aws_eip" "nat_gateway" {
  count = length(aws_subnet.private_subnets_ipv4only)

  vpc = true

  tags = {
    Name = "${var.vpc_name}${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(aws_subnet.private_subnets_ipv4only)

  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.private_subnets_ipv4only[count.index].id

  tags = {
    Name = "${var.vpc_name}${count.index}"
  }
}

output "nat_gateway_ips" {
  value = aws_eip.nat_gateway[*].public_ip
}


# =====================
#  Route Table Update  
# =====================

resource "aws_route_table" "private_subnets_ipv4only" {
  count = length(aws_subnet.private_subnets_ipv4only)

  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_eip.nat_gateway[count.index].id
  }
}

resource "aws_route_table_association" "private_subnets_ipv4only" {
  count = length(aws_subnet.private_subnets_ipv4only)

  subnet_id      = aws_subnet.private_subnets_ipv4only[count.index].id
  route_table_id = aws_route_table.private_subnets_ipv4only[count.index].id
}

