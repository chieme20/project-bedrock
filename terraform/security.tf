resource "aws_security_group" "eks_cluster_sg" {
  name        = "project-bedrock-cluster-sg-${random_string.suffix.result}"
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
  name        = "project-bedrock-node-sg-${random_string.suffix.result}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_default_vpc.bedrock_vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}