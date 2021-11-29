resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr_block
  enable_dns_hostnames  = true

  tags = {
    Environment = var.environment
    Name        = var.vpc_name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id       = aws_eip.eip.allocation_id
  subnet_id           = aws_subnet.public_subnet_1.id
  connectivity_type   = var.connectivity_type
  tags = {
    Environment = var.environment
    Name        = "NAT Gateway for ${var.vpc_name}"
 }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment
    Name        = "IGW for ${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_1_cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.subnet_availability_zone_1

  tags = {
    Environment = var.environment
    Name        = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_2_cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.subnet_availability_zone_2

  tags = {
    Environment = var.environment
    Name        = "public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_1_cidr_block
  map_public_ip_on_launch = false
  availability_zone = var.subnet_availability_zone_1

  tags = {
    Environment = var.environment
    Name        = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_2_cidr_block
  map_public_ip_on_launch = false
  availability_zone = var.subnet_availability_zone_2

  tags = {
    Environment = var.environment
    Name        = "private_subnet_2"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = var.environment
    Name        = "Route table for public subnet"
  }
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Environment = var.environment
    Name        = "Route table for private subnet"
  }
}

resource "aws_route_table_association" "route_association_public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_association_private_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "route_association_public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_association_private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_network_acl" "acl_public" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  egress {
      # Allow all
      protocol   = "all"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }

  ingress {
    # Allow all
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Environment = var.environment
    Name        = "ACL for public subnets"
  }
}


resource "aws_network_acl" "acl_private" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  egress {
    # Allow all
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  ingress {
    # Allow all
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Environment = var.environment
    Name        = "ACL for private subnets"
  }
}

resource "aws_eip" "eip" {
  vpc      = true
  tags = {
    Environment = var.environment
    Name        = "EIP for NAT Gateway"
  }
}