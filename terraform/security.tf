
resource "aws_security_group" "eks_cluster_sg" {
  name        = "project-bedrock-cluster-sg"
  description = "Cluster control plane security group"
  vpc_id      = aws_vpc.bedrock_vpc.id

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project-bedrock-cluster-sg"
  }
}

resource "aws_security_group" "eks_nodes_sg" {
  name        = "project-bedrock-node-sg"
  description = "Security group for all nodes in the bedrock cluster"
  vpc_id      = aws_vpc.bedrock_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project-bedrock-node-sg"
  }
}