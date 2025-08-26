# project-webapp
Project to host a webapp

# GKE Cluster Provisioning with Terraform

This repository contains Terraform code to provision **Google Kubernetes Engine (GKE)** clusters for multiple environments (`staging` and `prod`) using **Terraform workspaces** for state isolation.

---

## 📂 Repository Structure

project-webapp/
├── infra/                       # Terraform configs
├── main.tf
├── variables.tf
├── outputs.tf
├── staging.tfvars
├── prod.tfvars
├── .gitignore
└── README.md


- **main.tf** – Terraform resources definition.
- **variables.tf** – Input variables.
- **outputs.tf** – Outputs after cluster creation.
- **staging.tfvars** – Variables for staging environment.
- **prod.tfvars** – Variables for production environment.
- **.gitignore** – Ignores Terraform local files and secrets.

---

## ⚙️ Prerequisites

1. Install [Terraform](https://developer.hashicorp.com/terraform/downloads).
2. Install [gcloud CLI](https://cloud.google.com/sdk/docs/install).
3. Authenticate with GCP:
   ```bash
   gcloud auth application-default login

### Usage

This apporach is using Terraform Workspaces in order to deploy each cluster.
In larger projects a separate state backends will be the best method.

1. **Initialize Terraform**
   ```bash
   cd infra
   terraform init

2. **Apply changes per environment**

Staging:
```bash
terraform workspace select staging
terraform apply -var-file=staging.tfvars


Production:
```bash
terraform workspace select prod
terraform apply -var-file=prod.tfvars

3. **Destroy clusters**

Staging:
```bash
terraform workspace select staging
terraform destroy -var-file=staging.tfvars

Production:
```bash
terraform workspace select prod
terraform destroy -var-file=prod.tfvars