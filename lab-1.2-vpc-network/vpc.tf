# ============================================
# LAB 1.2: VPC AND NETWORK SETUP
# ============================================

# VPC
resource "aws_vpc" "data_platform_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "data-platform-vpc-tf"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.data_platform_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-1a-tf"
  }
}

# Private Subnet 1
resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.data_platform_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1a-tf"
  }
}

# Private Subnet 2
resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.data_platform_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-1b-tf"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "data_platform_igw" {
  vpc_id = aws_vpc.data_platform_vpc.id

  tags = {
    Name = "data-platform-igw-tf"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.data_platform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.data_platform_igw.id
  }

  tags = {
    Name = "public-route-table-tf"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.data_platform_vpc.id

  tags = {
    Name = "private-route-table-tf"
  }
}

resource "aws_route_table_association" "private_subnet_1a_association" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_1b_association" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_route_table.id
}
