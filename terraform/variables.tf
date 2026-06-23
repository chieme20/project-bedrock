variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "project-bedrock-vpc-v5"
}

variable "cluster_name" {
  type    = string
  default = "project-bedrock-cluster-v5"
}

variable "student_id" {
  type    = string
  default = "alt-soe-025-3671" 
}