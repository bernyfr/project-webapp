# DevOps Assignment – Hello App on GKE

This repository contains a simple "Hello World" web application deployed on **Google Kubernetes Engine (GKE)** using **Terraform**, **Helm**, and **GitHub Actions** CI/CD.

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [Section #1 – Infrastructure Provisioning](#section-1---infrastructure-provisioning)
3. [Section #2 – Application Development & Containerization](#section-2---application-development--containerization)
4. [Section #3 – Helm Deployment](#section-3---helm-deployment)
5. [Section #4 – CI/CD Pipeline](#section-4---cicd-pipeline)
6. [Security Considerations](#security-considerations)
7. [Testing](#testing)
8. [Cleanup](#cleanup)

---

## Infrastructure Provisioning

We provision **two GKE clusters** (staging & production) using Terraform:

- Private clusters with RBAC enabled
- Configurable parameters:
  - Cluster name
  - Node type
  - Node count
  - Region/zone
- Separate **Terraform workspaces** for `staging` and `production`

### Example Commands

```bash
# Initialize Terraform
terraform init

# Select workspace
terraform workspace select staging || terraform workspace new staging

# Plan & apply
terraform plan -var-file=staging.tfvars
terraform apply -var-file=staging.tfvars

# Repeat for prod workspace
terraform workspace select prod || terraform workspace new prod
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

## Application Development & Containerization

We use a Python Flask “Hello World” app.

Steps:

- Dockerize the app
- Push to Google Container Registry (GCR)

### Example Commands
```bash
Build and Push Docker Image

# Build image
docker build -t gcr.io/<PROJECT_ID>/hello-app:latest ./app

# Authenticate with GCP
gcloud auth configure-docker

# Push image
docker push gcr.io/<PROJECT_ID>/hello-app:latest

# Verify image in GCR
gcloud container images list-tags gcr.io/<PROJECT_ID>/hello-app
```

## Helm Deployment

Helm chart webapp created for multi-environment deployment

Templates:
* deployment.yaml
* service.yaml

Environment-specific values files:
* values-staging.yaml
* values-prod.yaml

Common values.yaml contains defaults

Deploy Locally (Template Rendering)
```bash
# Staging
helm template webapp ./helm/webapp -f ./helm/webapp/values-staging.yaml --namespace staging

# Production
helm template webapp ./helm/webapp -f ./helm/webapp/values-prod.yaml --namespace production
```

## CI/CD Pipeline

Pipeline implemented using GitHub Actions:

- Build – Build Docker image & push to GCR
- Deploy to Staging – Helm deploy to staging environment
- Approve – Manual approval:
   * GitHub actor must be in ALLOWED_PROD_USERS
   * Commit must be tagged with Semantic Versioning (vX.Y.Z)

- Deploy to Production – Helm deploy to production environment

Secrets Required

* GCP_SA_KEY	      (Service account JSON for GCP)
* GCP_PROJECT_ID	   (GCP project ID)
* ALLOWED_PROD_USERS	(Comma-separated GitHub usernames allowed to deploy production)

Trigger
* Staging – Any push to main
* Production – Push with valid SemVer tag (e.g., v1.0.0)

### Security Considerations

No sensitive information committed to repo
GCP credentials stored in GitHub Secrets
Helm values use environment-specific files, repository paths are parameterized
Only allowed users can deploy to production

### Testing

Verify Docker image in GCR
Test Helm templates locally
Ensure staging deployment works via CI/CD
Tag a commit with vX.Y.Z to test production deployment
Confirm manual approval and user restriction logic

### Cleanup

To avoid GCP billing:
```bash
# Destroy staging
terraform workspace select staging
terraform destroy -var-file=staging.tfvars

# Destroy production
terraform workspace select prod
terraform destroy -var-file=prod.tfvars
```