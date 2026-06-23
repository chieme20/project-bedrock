# Look up the existing default VPC that AWS automatically provides
data "aws_vpc" "bedrock_vpc" {
  default = true
}

# Look up all default subnets sitting inside that VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.bedrock_vpc.id]
  }
}