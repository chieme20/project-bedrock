# ==============================================================================
# AltSchool Karatu 2025 Third Semester Capstone Project - "Project Bedrock"
# Root Configuration & Standard Local State Backend
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # S3 backend completely removed to bypass AWS 403 / Bucket validation errors
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}