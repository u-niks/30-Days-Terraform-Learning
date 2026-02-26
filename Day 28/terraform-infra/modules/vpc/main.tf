# VPC
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-vpc"
        }
    )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-igw"
        }
    )
}

# Public Subnets (Web Tier)
resource "aws_subnet" "public_subnets" {
    count                   = length(var.availability_zones)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidrs[count.index]
    availability_zone       = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-public-subnet-${count.index + 1}"
            Tier = "public"
        }
    )
}

# Frontend Private Subnets (App Tier - Frontend)
resource "aws_subnet" "frontend_subnets" {
    count             = length(var.frontend_subnet_cidrs)
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.frontend_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-frontend-subnet-${count.index + 1}"
            Tier = "frontend"
        }
    )
}

# Backend Private Subnets (App Tier - Backend)
resource "aws_subnet" "backend_subnets" {
    count             = length(var.backend_subnet_cidrs)
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.backend_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-backend-subnet-${count.index}"
            Tier = "backend"
        }
    )
}

# Database Isolated Subnets (Data Tier)
resource "aws_subnet" "database_subnets" {
    count             = length(var.database_subnet_cidrs)
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.database_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-database-subnet-${count.index}"
            Tier = "database"
        }
    )
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip" {
    count  = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0
    domain = "vpc"
    
    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-eip"
        }
    )

    depends_on = [ aws_internet_gateway.main ]
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
    count         = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0
    allocation_id = aws_eip.nat_eip[count.index].id
    subnet_id     = aws_subnet.public_subnets[count.index].id

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-nat-gw-${count.index + 1}"
        }
    )

    depends_on = [ aws_internet_gateway.main ]
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-public-rt"
            Tier = "public"
        }
    )
}

# Route for Public Subnets to Internet Gateway
resource "aws_route" "public_internet_route" {
    route_table_id         = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main.id
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_rta" {
    count          = length(var.availability_zones)
    subnet_id      = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

# Route Tables for Frontend Private Subnets
resource "aws_route_table" "frontend_rt" {
    count  = var.enable_nat_gateway ? length(var.availability_zones) : 0
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-frontend-rt-${count.index + 1}"
            Tier = "frontend"
        }
    )
}

# Route for Frontend Subnets to NAT Gateway
resource "aws_route" "frontend_route" {
    count                  = var.enable_nat_gateway ? length(var.availability_zones) : 0
    route_table_id         = aws_route_table.frontend_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : aws_nat_gateway.nat_gateway[count.index].id
}

# Associate Frontend Subnets with Frontend Route Tables
resource "aws_route_table_association" "frontend_rta" {
    count          = length(var.availability_zones)
    subnet_id      = aws_subnet.frontend_subnets[count.index].id
    route_table_id = var.enable_nat_gateway ? aws_route_table.frontend_rt[count.index].id : null
}

# Route Tables for Backend Private Subnets
resource "aws_route_table" "backend_rt" {
    count  = var.enable_nat_gateway ? length(var.availability_zones) : 0
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-backend-rt-${count.index + 1}"
            Tier = "backend"
        }
    )
}

# Route for Backend Subnets to NAT Gateway
resource "aws_route" "backend_route" {
    count                  = var.enable_nat_gateway ? length(var.availability_zones) : 0
    route_table_id         = aws_route_table.backend_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "backend_rta" {
    count          = length(var.availability_zones)
    subnet_id      = aws_subnet.backend_subnets[count.index].id
    route_table_id = var.enable_nat_gateway ? aws_route_table.backend_rt[count.index].id : null
}

# Route Table for Database Subnets (No internet access)
resource "aws_route_table" "database_rt" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.tags, {
            Name = "${var.environment}-${var.project}-database-rt"
            Tier = "database"
        }
    )
}

# Associate Database Subnets with Database Route Table
resource "aws_route_table_association" "database_rta" {
    count          = length(var.availability_zones)
    subnet_id      = aws_subnet.database_subnets[count.index].id
    route_table_id = aws_route_table.database_rt.id
}