# Adopt the existing default VPC in your account
resource "aws_default_vpc" "bedrock_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

# Fetch the existing default subnets already built inside your AWS account
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.bedrock_vpc.id]
  }
}

# Use the existing discovered subnets instead of building new ones
resource "aws_subnet" "private_1" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_default_vpc.bedrock_vpc.id
  
  # Point this to the first default subnet discovered
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_subnet" "private_2" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_default_vpc.bedrock_vpc.id

  # Point this to the second default subnet discovered
  lifecycle {
    ignore_changes = all
  }
}