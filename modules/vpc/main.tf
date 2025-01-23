resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private subnet ${count.index + 1}"
  }
}

# VPC Route Table Section - public route
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

# Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Public Route Table Association
resource "aws_route_table_association" "public_rt_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# VPC Route Table Section - private route

resource "aws_eip" "elastic_IP_address" {
  count  = length(var.private_subnet_cidrs)
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.elastic_IP_address[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "${var.vpc_name}-nat-gateway-${count.index}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Private Route Tables
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index}"
  }
}

# Private Routes
resource "aws_route" "private_route" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

# Network ACL Section
# resource "aws_network_acl" "vpc_ACL" {
#   vpc_id = aws_vpc.main_vpc.id
#   tags = {
#     Name = "${var.vpc_name}-NACL"
#   }
# }

# resource "aws_network_acl_rule" "public_ssh_inbound" {
#   network_acl_id = aws_network_acl.vpc_ACL.id
#   rule_number    = 120
#   rule_action    = "allow"
#   protocol       = "6" #tcl protocol
#   egress         = false
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 22
#   to_port        = 22
# }

# resource "aws_network_acl_rule" "public_http_inbound" {
#   network_acl_id = aws_network_acl.vpc_ACL.id
#   rule_number    = 100
#   rule_action    = "allow"
#   protocol       = "6"
#   egress         = false
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 80
#   to_port        = 80
# }

# resource "aws_network_acl_rule" "public_https_inbound" {
#   network_acl_id = aws_network_acl.vpc_ACL.id
#   rule_number    = 110
#   rule_action    = "allow"
#   protocol       = "6"
#   egress         = false
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 443
#   to_port        = 443
# }

# resource "aws_network_acl_rule" "public_ssh_outbound" {
#   network_acl_id = aws_network_acl.vpc_ACL.id
#   rule_number    = 121
#   rule_action    = "allow"
#   protocol       = "6"
#   egress         = true
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 22
#   to_port        = 22
# }

# resource "aws_network_acl_rule" "public_all_outbound" {
#   network_acl_id = aws_network_acl.vpc_ACL.id
#   rule_number    = 200
#   rule_action    = "allow"
#   protocol       = "-1"
#   egress         = true
#   cidr_block     = "0.0.0.0/0"
# }

# resource "aws_network_acl_rule" "public_deny_all_inbound" {
#   network_acl_id = aws_network_acl.vpc_ACL.id
#   rule_number    = 300
#   rule_action    = "deny"
#   protocol       = "-1"
#   egress         = false
#   cidr_block     = "0.0.0.0/0"
# }


# # Associate the custom NACL with the public subnets
# resource "aws_network_acl_association" "public_subnet_acl_association" {
#   count          = length(aws_subnet.public_subnet)
#   subnet_id      = aws_subnet.public_subnet[count.index].id
#   network_acl_id = aws_network_acl.vpc_ACL.id
# }

# # Associate the custom NACL with the private subnets
# resource "aws_network_acl_association" "private_subnet_acl_association" {
#   count          = length(aws_subnet.private_subnet)
#   subnet_id      = aws_subnet.private_subnet[count.index].id
#   network_acl_id = aws_network_acl.vpc_ACL.id
# }
