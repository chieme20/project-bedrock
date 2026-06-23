resource "aws_iam_role" "lambda_role" {
  name = "project-bedrock-lambda-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "asset_processor" {
  filename      = "lambda_function.zip"
  function_name = "bedrock-asset-processor-${random_string.suffix.result}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  source_code_hash = filebase64sha256("lambda_function.zip")

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs
  ]
}