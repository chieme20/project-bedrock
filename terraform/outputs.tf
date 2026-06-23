output "vpc_id" {
  value       = data.aws_vpc.bedrock_vpc.id
  description = "The ID of the existing default VPC network"
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets_bucket.id
}

output "dev_user_access_key_id" {
  value = aws_iam_access_key.dev_user_keys.id
}

output "dev_user_secret_access_key" {
  value     = aws_iam_access_key.dev_user_keys.secret
  sensitive = true
}

output "region" {
  value = var.aws_region
}