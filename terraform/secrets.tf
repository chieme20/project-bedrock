resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "project-bedrock-db-secrets-v6"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "bedrock_admin"
    password = "SecurePassword123!"
  })
}