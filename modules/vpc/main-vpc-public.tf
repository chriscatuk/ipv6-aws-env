# =====================
#    IGW CREATION   
# =====================
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "DummyNatGateway"
  }
}

# =====================
#  Route Table Update  
# =====================
resource "aws_default_route_table" "route" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_default_route_table.route.id
}
