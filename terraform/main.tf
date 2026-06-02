# ==============================================================================
# AltSchool Karatu 2025 Third Semester Capstone Project - "Project Bedrock"
# Root Configuration & Remote State Management Only
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  
  backend "s3" {
    bucket         = "bedrock-tfstate-alt-soe-3671"
    key            = "stage/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}