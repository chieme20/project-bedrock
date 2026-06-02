# 🚀 Project Bedrock - Altschool Cloud/DevOps Capstone

This repository contains the infrastructure-as-code and configuration deployment manifests for running the upstream `aws-containers/retail-store-sample-app` in a highly available, secure, multi-AZ production environment on AWS.

## 🏗️ What We Built (Phase 1 Completed)
* **VPC Networking (`vpc.tf`):** Multi-AZ deployment spanning public and private networks with custom ingress tags.
* **Compute Engine (`eks.tf`):** Secure EKS cluster settings with automated management plane control logging.
* **Database Engine (`databases.tf`):** Fully isolated MySQL, PostgreSQL, and DynamoDB storage engines.
* **Secrets Vault (`secrets.tf`):** Automated encryption parameters via AWS Secrets Manager.
* **RBAC Controls (`developer.tf` / `dev-rbac.yaml`):** Least-privilege profile mapping for user `bedrock-dev-view`.

## 🛫 Step-by-Step Execution Plan (When You Return)

When you return from your 5-day trip, open your PowerShell terminal here and execute these exact commands to launch the infrastructure:

### 1. Initialize AWS Credentials
```powershell
aws configure
# Enter your AWS Access Key, Secret Key, and set default region to 'us-east-1'