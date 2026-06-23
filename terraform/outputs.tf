output "region" {
  value       = var.aws_region
  description = "AWS Target Region"
}

output "vpc_id" {
  value       = aws_default_vpc.bedrock_vpc.id
  description = "The ID of the generated VPC network"
}

output "cluster_name" {
  value       = aws_eks_cluster.bedrock_cluster.name
  description = "EKS Cluster Name"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.bedrock_cluster.endpoint
  description = "EKS Control Plane Control Endpoint"
}

output "assets_bucket_name" {
  value       = "bedrock-assets-${var.student_id}"
  description = "Target S3 Bucket name for asset processing"
}

output "dev_user_access_key_id" {
  value       = aws_iam_access_key.dev_user_keys.id
  description = "Submit this value as the Access Key ID in your grading doc"
}

output "dev_user_secret_access_key" {
  value       = aws_iam_access_key.dev_user_keys.secret
  sensitive   = true 
  description = "Submit this value as the Secret Access Key in your grading doc"
}