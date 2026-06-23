# The missing S3 bucket resource declared explicitly
resource "aws_s3_bucket" "assets_bucket" {
  bucket        = "bedrock-assets-${var.student_id}"
  force_destroy = true # Allows clean destruction later if needed
}

resource "aws_iam_user" "dev_user" {
  name = "project-bedrock-developer-${var.student_id}"
}

resource "aws_iam_access_key" "dev_user_keys" {
  user = aws_iam_user.dev_user.name
}

resource "aws_iam_user_policy" "dev_user_s3_upload" {
  name = "project-bedrock-developer-s3-upload-policy"
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