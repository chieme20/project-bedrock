# Adopt the existing default VPC in your account
resource "aws_default_vpc" "bedrock_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

# Fetch all default subnets already existing in your account
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.bedrock_vpc.id]
  }
}

# Fetch the individual subnet details
data "aws_subnet" "sub1" {
  id = data.aws_subnets.default.ids[0]
}

data "aws_subnet" "sub2" {
  id = data.aws_subnets.default.ids[1]
}

# Map our resources directly to them to bypass CIDR creation conflicts
resource "aws_subnet" "private_1" {
  vpc_id            = aws_default_vpc.bedrock_vpc.id
  cidr_block        = data.aws_subnet.sub1.cidr_block
  availability_zone = data.aws_subnet.sub1.availability_zone

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_default_vpc.bedrock_vpc.id
  cidr_block        = data.aws_subnet.sub2.cidr_block
  availability_zone = data.aws_subnet.sub2.availability_zone

  lifecycle {
    ignore_changes = all
  }
}