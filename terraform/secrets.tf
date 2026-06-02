resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "project-bedrock-db-secrets"
  recovery_window_in_days = 0 
}

resource "aws_secretsmanager_secret_version" "db_credentials_values" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    mysql_host     = aws_db_instance.mysql_catalog.address
    mysql_user     = aws_db_instance.mysql_catalog.username
    mysql_password = aws_db_instance.mysql_catalog.password
    mysql_database = aws_db_instance.mysql_catalog.db_name

    postgres_host     = aws_db_instance.postgres_orders.address
    postgres_user     = aws_db_instance.postgres_orders.username
    postgres_password = aws_db_instance.postgres_orders.password
    postgres_database = aws_db_instance.postgres_orders.db_name
    
    dynamodb_table    = aws_dynamodb_table.carts_table.name
  })
}