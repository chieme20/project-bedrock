# Adopt the existing default VPC
resource "aws_default_vpc" "bedrock_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

# 1. Map directly to the first default subnet slot
resource "aws_subnet" "private_1" {
  vpc_id            = aws_default_vpc.bedrock_vpc.id
  cidr_block        = "172.31.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "project-bedrock-private-1-${random_string.suffix.result}"
  }
}

# 2. Map directly to the second default subnet slot
resource "aws_subnet" "private_2" {
  vpc_id            = aws_default_vpc.bedrock_vpc.id
  cidr_block        = "172.31.16.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "project-bedrock-private-2-${random_string.suffix.result}"
  }
}

# =====================================================================
# FORCE TERRAFORM TO IMPORT THE EXISTING SUBNETS INSTEAD OF CREATING THEM
# =====================================================================

import {
  to = aws_subnet.private_1
  id = "subnet-03d2d8e36b7935053" # Automatically binds the existing us-east-1a subnet
}

import {
  to = aws_subnet.private_2
  id = "subnet-0de2d8e36b7935054" # Automatically binds the existing us-east-1b subnet
}