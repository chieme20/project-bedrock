resource "aws_iam_user" "dev_user" {
name = "project-bedrock-cluster-execution-role-v3"
}


resource "aws_iam_access_key" "dev_user_keys" {
  user = aws_iam_user.dev_user.name
}

resource "aws_iam_user_policy_attachment" "console_read_only" {
  user       = aws_iam_user.dev_user.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy" "s3_upload_access" {
  name = "bedrock-dev-s3-upload-policy"
  user = aws_iam_user.dev_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.assets_bucket.arn}/*"]
      }
    ]
  })
}

resource "aws_eks_access_entry" "dev_cluster_access" {
  cluster_name      = aws_eks_cluster.bedrock_cluster.name
  principal_arn     = aws_iam_user.dev_user.arn
  kubernetes_groups = ["reader-group"] 
  type              = "STANDARD"
}

resource "aws_iam_user_policy" "dev_user_s3_upload" {
  name = "bedrock-dev-s3-upload-policy"
  user = "bedrock-dev-view" 

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = ["arn:aws:s3:::bedrock-assets-${var.student_id}/*"]
      }
    ]
  })
}