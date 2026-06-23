terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false  # Keeps it lowercase for S3 bucket compatibility
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "student_id" {
  type    = string
  default = "alt-soe-025-3671" 
}