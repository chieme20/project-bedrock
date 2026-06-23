# Create a fresh, dedicated VPC to avoid default network congestion
resource "aws_vpc" "bedrock_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Fetch availability zones dynamically
data "aws_availability_zones" "available" {
  state = "available"
}

# Create fresh, clean private subnets inside the new VPC space
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.bedrock_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "project-bedrock-private-1-${random_string.suffix.result}"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.bedrock_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "project-bedrock-private-2-${random_string.suffix.result}"
  }
}

# Internet Gateway to allow EKS control plane routing
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.bedrock_vpc.id

  tags = {
    Name = "project-bedrock-igw"
  }
}