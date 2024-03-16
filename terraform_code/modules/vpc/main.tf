provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "devops-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "devops-training"
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = var.vpc_pub1_sub_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-training-pub1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = var.vpc_pub2_sub_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-training-pub2"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.devops-vpc.id
  tags = {
    Name = "devops-training-igw"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.devops-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "devops-training-rt"
  }
}

resource "aws_route_table_association" "route-table-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_route_table_association" "route-table-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_security_group" "devops-vpc-sg" {
  name   = "devops-training-sg"
  vpc_id = aws_vpc.devops-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc_sg_cidr_blocks
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_sg_cidr_blocks
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.vpc_sg_cidr_blocks
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-training-sg"
  }
}