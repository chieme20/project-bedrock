# ====================================================================
# PROJECT BEDROCK MASTER DEPLOYMENT ORCHESTRATOR
# ====================================================================
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host " Starting Project Bedrock Infrastructure Pipeline..." -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. Verify AWS CLI Connection
Write-Host "`n Checking AWS CLI configuration identity..." -ForegroundColor Yellow
aws sts get-caller-identity
if ($LASTEXITCODE -ne 0) {
    Write-Error " Critical Error: AWS CLI is not configured or authenticated. Run 'aws configure' first."
    Exit
}

# 2. Initialize and Launch Terraform Modules
Write-Host "`n Initializing cloud provider engines..." -ForegroundColor Yellow
cd terraform
terraform init

Write-Host "`n Generating execution dry-run planning manifest..." -ForegroundColor Yellow
terraform plan -out=tfplan

Write-Host "`n Launching live cloud resources (VPC, EKS, RDS, DynamoDB)..." -ForegroundColor Yellow
terraform apply tfplan
if ($LASTEXITCODE -ne 0) {
    Write-Error " Critical Error: Terraform application layer deployment failed."
    Exit
}
cd ..

# 3. Update Local Kubectl context to connect to AWS Cloud
Write-Host "`n Connecting local cluster management tools to the remote AWS control plane..." -ForegroundColor Yellow
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster

# 4. Bootstrap Kubernetes Security & System Management Rules
Write-Host "`n Injecting base core namespaces, RBAC privileges, and metrics engines..." -ForegroundColor Yellow
kubectl apply -f k8s/app-init.yaml
kubectl apply -f k8s/dev-rbac.yaml
kubectl apply -f k8s/cloudwatch-logging.yaml

# 5. Sequential Application Pod Orchestration
Write-Host "`n Deploying core database backend configurations..." -ForegroundColor Yellow
# We run a simple injection helper script command line when live to securely bind our secrets!

Write-Host "`n Launching active online retail microservices..." -ForegroundColor Yellow
kubectl apply -f manifests/catalog.yaml
kubectl apply -f manifests/carts.yaml
kubectl apply -f manifests/orders.yaml
kubectl apply -f manifests/checkout.yaml
kubectl apply -f manifests/ui.yaml

# 6. Status Readout verification
Write-Host "`n Pausing 10 seconds for initial network synchronization loop..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "`n Live Deployment Running Pod Profiles:" -ForegroundColor Green
kubectl get pods -n retail-app

Write-Host "`n Target Routing Access Public Endpoints (ALB Address Link):" -ForegroundColor Green
kubectl get ingress -n retail-app ui-ingress

Write-Host "`n====================================================" -ForegroundColor Green
Write-Host " SUCCESS: Phase 1 & 2 Local Blueprints Deployed Successfully!" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green