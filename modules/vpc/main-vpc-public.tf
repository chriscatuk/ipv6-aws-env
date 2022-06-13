# =====================
#    IGW CREATION   
# =====================
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_name
  }
}

# =====================
#     NAT GATEWAY   
# =====================
# used by both IPv4 and IPv6 private subnets
resource "aws_eip" "nat_gateway" {
  count = length(aws_subnet.public_subnets)

  vpc = true

  tags = {
    Name = "${var.vpc_name}-${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(aws_subnet.public_subnets)

  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.vpc_name}-${count.index}"
  }
}

output "nat_gateway_ips" {
  value = aws_eip.nat_gateway[*].public_ip
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
