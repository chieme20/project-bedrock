# Adopt the existing default VPC in your account
resource "aws_default_vpc" "bedrock_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

# Fetch the existing availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Use default subnets or create mock subnets tied to the default network
resource "aws_subnet" "private_1" {
  vpc_id            = aws_default_vpc.bedrock_vpc.id
  cidr_block        = "172.31.192.0/20"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "project-bedrock-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_default_vpc.bedrock_vpc.id
  cidr_block        = "172.31.208.0/20"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "project-bedrock-private-2"
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "project-bedrock-cluster-sg"
  description = "Cluster control plane communications"
  vpc_id      = aws_default_vpc.bedrock_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "eks_nodes_sg" {
  name        = "project-bedrock-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_default_vpc.bedrock_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}