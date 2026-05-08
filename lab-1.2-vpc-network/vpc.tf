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
