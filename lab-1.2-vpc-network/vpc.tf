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

# Associate Public Subnet with Public Route Table
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

# Associate Private Subnet 1 with Private Route Table
resource "aws_route_table_association" "private_subnet_1a_association" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate Private Subnet 2 with Private Route Table
resource "aws_route_table_association" "private_subnet_1b_association" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_route_table.id
}

# Security Group - Public NAT
resource "aws_security_group" "sg_public_nat" {
  name        = "public-nat-tf"
  description = "Security group for public subnet with NAT Gateway"
  vpc_id      = aws_vpc.data_platform_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-nat-tf"
  }
}

# Security Group - Private Compute
resource "aws_security_group" "sg_private_compute" {
  name        = "private-compute-tf"
  description = "Security group for compute in private subnets"
  vpc_id      = aws_vpc.data_platform_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-compute-tf"
  }
}

# Security Group - Private DB
resource "aws_security_group" "sg_private_db" {
  name        = "private-db-tf"
  description = "Security group for RDS databases in private subnets"
  vpc_id      = aws_vpc.data_platform_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_private_compute.id]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_private_compute.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-db-tf"
  }
}

# VPC Endpoint - S3 Gateway (FREE)
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.data_platform_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_route_table.id]

  tags = {
    Name = "s3-vpc-endpoint-tf"
  }
}

# VPC Endpoint - DynamoDB Gateway (FREE)
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.data_platform_vpc.id
  service_name      = "com.amazonaws.us-east-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_route_table.id]

  tags = {
    Name = "dynamodb-vpc-endpoint-tf"
  }
}

# VPC Endpoint - Secrets Manager Interface
resource "aws_vpc_endpoint" "secretsmanager_endpoint" {
  vpc_id              = aws_vpc.data_platform_vpc.id
  service_name        = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]
  security_group_ids  = [aws_security_group.sg_private_compute.id]
  private_dns_enabled = true

  tags = {
    Name = "secretsmanager-vpc-endpoint-tf"
  }
}
