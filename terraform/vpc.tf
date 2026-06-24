# Adopt the existing default VPC
data "aws_vpc" "bedrock_vpc" {
  default = true
}

# Fetch all default subnets, but strictly filter out us-east-1e to please EKS
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.bedrock_vpc.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}