resource "aws_vpc" "this" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = local.vpc_name
    Environment = var.environment
    Project     = var.project_name
  }
}


resource "aws_subnet" "public_a" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.public_cidr[0]

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name = local.public_subnet_name_a
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.this.id

  cidr_block = var.public_cidr[1]

  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = local.public_subnet_name_b
  }
}

resource "aws_subnet" "private_a" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_cidr[0]

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = local.private_subnet_name_a
  }
}

resource "aws_subnet" "private_b" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_cidr[1]

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = local.private_subnet_name_b
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = local.internet_gateway_name
  }
}

resource "aws_eip" "nat" {
  
  domain = "vpc" 

  tags = {
    Name = local.nat_ip_name
  }
}

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_a.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = local.nat_gateway_name
  }
    
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = local.route_table_name
  }
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = local.private_route_table_name
  }
}

resource "aws_route_table_association" "public_a" {

  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_b" {

  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}