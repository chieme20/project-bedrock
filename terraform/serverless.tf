resource "aws_s3_bucket" "assets_bucket" {
  bucket        = "bedrock-assets-${var.student_id}-${random_string.suffix.result}"
  force_destroy = true
}

resource "aws_iam_role" "lambda_role" {
  name = "project-bedrock-lambda-execution-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "asset_processor" {
  filename      = "${path.module}/lambda_function.zip"
  function_name = "bedrock-asset-processor-v6"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.assets_bucket.id
    }
  }
}