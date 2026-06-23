variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "project-bedrock-vpc-v4" # <-- Changed to v4
}

variable "cluster_name" {
  type    = string
  default = "project-bedrock-cluster-v4" # <-- Changed to v4
}

variable "student_id" {
  type    = string
  default = "alt-soe-025-3671" 
}