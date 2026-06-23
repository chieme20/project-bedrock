resource "aws_db_subnet_group" "db_subnets" {
name = "project-bedrock-db-subnet-group-v5"
  description = "Private subnets for secure RDS instances"
  subnet_ids  = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "project-bedrock-db-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "project-bedrock-database-sg"
  description = "Isolate database traffic to EKS cluster node pools"
  vpc_id      = aws_vpc.bedrock_vpc.id

  
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

resource "aws_db_instance" "mysql_catalog" {
  identifier             = "bedrock-catalog-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro" 
  allocated_storage      = 20
  db_name                = "catalog"
  username               = "dbadmin"
  # CHANGE THIS LINE: Remove the @ symbol
  password               = "chichiBekee2026" 
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true                       
}

resource "aws_db_instance" "postgres_orders" {
  identifier             = "bedrock-orders-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  db_name                = "orders"
  username               = "dbadmin"
   
  password               = "chichiBekee2026"
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
}

resource "aws_dynamodb_table" "carts_table" {
name = "project-bedrock-carts-v5"
  billing_mode   = "PAY_PER_REQUEST" 
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S" 
  }
}