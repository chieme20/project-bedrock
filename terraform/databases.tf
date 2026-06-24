resource "aws_db_subnet_group" "db_subnets" {
  name        = "project-bedrock-db-subnet-group-${random_string.suffix.result}"
  description = "Private subnets for secure RDS instances"
  subnet_ids  = data.aws_subnets.default.ids 

  tags = {
    Name = "project-bedrock-db-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "project-bedrock-database-sg-${random_string.suffix.result}"
  description = "Isolate database traffic to EKS cluster node pools"
  vpc_id      = data.aws_vpc.bedrock_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes_sg.id]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project-bedrock-database-sg"
  }
}

resource "aws_dynamodb_table" "carts_table" {
  name         = "project-bedrock-carts-${random_string.suffix.result}"
  billing_mode = "PAY_PER_REQUEST" 
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S" 
  }
}