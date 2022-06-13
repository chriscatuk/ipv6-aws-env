# =====================
#    Egress GATEWAY   
# =====================

resource "aws_egress_only_internet_gateway" "egw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_name
  }
}

# =====================
#  Route Table Update  
# =====================

resource "aws_route_table" "private_subnets_ipv6only" {
  vpc_id = aws_vpc.vpc.id
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egw.id
  }
  tags = {
    Name = "${var.vpc_name}-private-ipv6only"
  }
}

resource "aws_route_table_association" "private_subnets_ipv6only" {
  count = length(aws_subnet.private_subnets_ipv6only)

  subnet_id      = aws_subnet.private_subnets_ipv6only[count.index].id
  route_table_id = aws_route_table.private_subnets_ipv6only.id
}

