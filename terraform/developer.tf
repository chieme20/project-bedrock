resource "aws_iam_user" "dev_user" {

  name = "bedrock-dev-view"
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


# EKS has an access entry map pattern that allows us to map this IAM user 
# directly into the Kubernetes cluster control core interface.
resource "aws_eks_access_entry" "dev_cluster_access" {
  cluster_name      = aws_eks_cluster.bedrock_cluster.name
  principal_arn     = aws_iam_user.dev_user.arn
  kubernetes_groups = ["reader-group"] # Maps them to this specific custom group name inside Kubernetes
  type              = "STANDARD"
}