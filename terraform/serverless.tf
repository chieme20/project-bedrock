resource "aws_s3_bucket" "assets_bucket" {
  bucket = "bedrock-assets-martina-chiemezuo"
  force_destroy = true 
}

resource "aws_s3_bucket_public_access_block" "assets_bucket_privacy" {
  bucket                  = aws_s3_bucket.assets_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "lambda_role" {
  name = "project-bedrock-lambda-execution-role"

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

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/process.py"
  output_path = "${path.module}/../lambda/process.zip"
}


resource "aws_lambda_function" "asset_processor" {
  function_name    = "bedrock-asset-processor"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "process.lambda_handler"  
  runtime          = "python3.11"
  timeout          = 15
}


resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets_bucket.arn
}


resource "aws_s3_bucket_notification" "bucket_trigger" {
  bucket = aws_s3_bucket.assets_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"] 
  }

  depends_on = [aws_lambda_permission.allow_s3_invocation]
}