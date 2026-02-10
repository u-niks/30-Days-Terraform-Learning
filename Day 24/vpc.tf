resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "public" {
    count                   = var.public_subnet_count
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidrs[count.index]
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = "public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count             = var.private_subnet_count
    vpc_id            = aws_vpc.main.id
    cidr_block        = element(var.private_subnet_cidrs, count.index)
    availability_zone = element(var.availability_zones, count.index)
    
    tags = {
        Name = "private-subnet-${count.index}"
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
        Name = "public-route-table"
    }
}

resource "aws_route" "public_route" {
    route_table_id         = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_route_table_association" "public_rta" {
    count          = var.public_subnet_count
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

# Create one Elastic IP per NAT Gateway
resource "aws_eip" "private_eip" {
    count  = var.private_subnet_count
    domain = "vpc"

    tags = {
        Name = "nat-eip-az-${count.index + 1}"
    }

    depends_on = [ aws_internet_gateway.public_igw ]
}

# Create one NAT Gateway per Availability Zone
resource "aws_nat_gateway" "private_nat" {
    count         = var.private_subnet_count
    allocation_id = aws_eip.private_eip[count.index].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = {
        Name = "nat-gateway-az-${count.index + 1}"
    }
}

# Create one route table per private subnet for HA
resource "aws_route_table" "private_rt" {
    count  = var.private_subnet_count
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "private-route-table-${count.index + 1}"
    }
}

# Route each private subnet's traffic through its corresponding NAT Gateway
resource "aws_route" "private_route" {
    count                  = var.private_subnet_count
    route_table_id         = aws_route_table.private_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.private_nat[count.index].id
}

# Associate each private subnet with its own route table
resource "aws_route_table_association" "private_rta" {
    count          = var.private_subnet_count
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private_rt[count.index].id
}
