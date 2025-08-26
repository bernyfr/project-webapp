variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "node_type" {
  type        = string
  description = "Machine type for GKE nodes"
  default     = "e2-medium"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the pool"
  default     = 2
}

variable "environment" {
  type        = string
  description = "Environment (staging/prod)"
}

variable "subnet_cidr" {
  description = "Primary subnet CIDR"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary range for Pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary range for Services"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the GKE master endpoint"
  type        = string
}
