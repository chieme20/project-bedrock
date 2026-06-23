resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "project-bedrock-vpc"
}

variable "student_id" {
  type    = string
  default = "alt-soe-025-3671" 
}


