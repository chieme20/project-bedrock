resource "aws_iam_user" "dev_user" {
  name = "bedrock-dev-view-v6"
}

resource "aws_iam_user_policy" "dev_user_s3_upload" {
  name = "bedrock-dev-s3-upload-policy"
  user = aws_iam_user.dev_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.assets_bucket.arn,
          "${aws_s3_bucket.assets_bucket.arn}/*"
        ]
      }
    ]
  })
}