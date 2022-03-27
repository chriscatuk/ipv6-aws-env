# =====================
#    VPC CREATION   
# =====================
resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = var.ipv6
  tags = {
    Name = var.vpc_name
  }
}

# =====================
#    IGW CREATION   
# =====================
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

# =====================
#   Subnets Creation
# =====================
data "aws_availability_zones" "available" {
}

locals {
  # define the subnet numbers to be used for that number of availablity zones
  newbits_per_az = {
    1 = 1
    2 = 2
    3 = 3
    4 = 3
    5 = 4
    6 = 4
    7 = 4
    8 = 4
  }
  # examples:
  # - /16 would allow 2 subnets  of /17 ( +1 ) that would cover 1 AZ with private + public subnet
  # - /16 would allow 4 subnets  of /18 ( +2 ) that would cover 2 AZ with private + public subnet
  # - /16 would allow 8 subnets  of /19 ( +3 ) that would cover 4 AZ with private + public subnet
  # - /16 would allow 16 subnets of /20 ( +4 ) that would cover 8 AZ with private + public subnet
  # 8 AZs is the maximum we would ask for
}

resource "aws_subnet" "public_subnets" {
  count = var.number_of_az

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, local.newbits_per_az[var.number_of_az], count.index)
  map_public_ip_on_launch = true

  # 10 + count.index will add 0a 0b 0c
  ipv6_cidr_block                 = var.ipv6 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 10 + count.index) : ""
  assign_ipv6_address_on_creation = true

  private_dns_hostname_type_on_launch            = "resource-name"
  enable_resource_name_dns_aaaa_record_on_launch = var.ipv6
  enable_resource_name_dns_a_record_on_launch    = true

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_subnet" "private_subnets_ipv4only" {
  count = var.number_of_az

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, local.newbits_per_az[var.number_of_az], count.index + var.number_of_az)
  map_public_ip_on_launch = false

  private_dns_hostname_type_on_launch            = "resource-name"
  enable_resource_name_dns_aaaa_record_on_launch = false
  enable_resource_name_dns_a_record_on_launch    = true

  tags = {
    Name = "${var.vpc_name}-private-ipv4"
  }
}

resource "aws_subnet" "private_subnets_ipv6only" {
  count = var.ipv6 ? var.number_of_az : 0

  ipv6_native = true

  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.vpc.id

  # 160 + count.index will add aa ab ac
  ipv6_cidr_block                 = var.ipv6 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 160 + count.index) : ""
  assign_ipv6_address_on_creation = true

  private_dns_hostname_type_on_launch            = "resource-name"
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_dns64                                   = true

  tags = {
    Name = "${var.vpc_name}-private-ipv6"
  }

}

# # =====================
# #  Route Table Update  #
# # =====================
# resource "aws_default_route_table" "route" {
#   default_route_table_id = aws_vpc.vpc.default_route_table_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   route {
#     ipv6_cidr_block = "::/0"
#     gateway_id      = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name        = var.vpcname
#     environment = var.environment
#     deployment  = var.deployment
#     OWNER       = var.OWNER
#     ROLE        = var.ROLE
#     AlwaysOn    = var.AlwaysOn
#   }
# }

# resource "aws_route_table_association" "route_sb_a" {
#   subnet_id      = aws_subnet.a.id
#   route_table_id = aws_default_route_table.route.id
# }

# resource "aws_route_table_association" "route_sb_b" {
#   subnet_id      = aws_subnet.b.id
#   route_table_id = aws_default_route_table.route.id
# }

# # resource "aws_route_table_association" "route_sb_c" {
# #     subnet_id      = "${aws_subnet.c.id}"
# #     route_table_id = "${aws_default_route_table.route.id}"
# # }

# # =====================###########
# #    SECURITY GROUP CREATION   
# # =====================###########
# resource "aws_default_security_group" "sg" {
#   vpc_id = aws_vpc.vpc.id

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }


#   tags = {
#     Name        = "${var.vpcname}-default"
#     environment = var.environment
#     deployment  = var.deployment
#     OWNER       = var.OWNER
#     ROLE        = var.ROLE
#     AlwaysOn    = var.AlwaysOn
#   }
# }

# # Handle dependancies on destroy
# resource "aws_security_group_rule" "ssh_jump" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.sg_bastion.id
#   security_group_id        = aws_default_security_group.sg.id
# }

# # =====================#######################
# #    SECURITY GROUP TO BE USED BY CLIENTS  
# # =====================#######################
# resource "aws_security_group" "sg_bastion" {
#   vpc_id      = aws_vpc.vpc.id
#   name        = "${var.vpcname}_bastion"
#   description = "${var.vpcname} Bastion"
#   ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = var.fw_ssh_cidr_ipv4
#     ipv6_cidr_blocks = var.fw_ssh_cidr_ipv6
#   }

#   ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.vpc.cidr_block]
#     ipv6_cidr_blocks = var.ipv6 ? [aws_vpc.vpc.ipv6_cidr_block] : []
#     description      = "same VPC"
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name        = "${var.vpcname}-bastion"
#     environment = var.environment
#     deployment  = var.deployment
#     OWNER       = var.OWNER
#     ROLE        = var.ROLE
#     AlwaysOn    = var.AlwaysOn
#   }
# }
