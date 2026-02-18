resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc-${var.environment}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${var.environment}-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-subnet-${var.environment}-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table-${var.environment}"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_route_table_association" "public_rta" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "main_eip" {
  count  = var.private_subnet_count
  domain = "vpc"

  tags = {
    Name = "main-nat-eip-${var.environment}-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.public_igw]
}

resource "aws_nat_gateway" "main_nat_gateway" {
  count         = var.private_subnet_count
  allocation_id = aws_eip.main_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "main-nat-gateway-${var.environment}-${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table-${var.environment}-${count.index + 1}"
  }
}

resource "aws_route" "private_route" {
  count                  = var.private_subnet_count
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_nat_gateway[count.index].id
}

resource "aws_route_table_association" "private_rta" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
