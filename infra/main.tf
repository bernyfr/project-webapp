terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# ----------------------------
# VPC Network
# ----------------------------
resource "google_compute_network" "gke_network" {
  name                    = "${var.environment}-gke-network"
  auto_create_subnetworks = false
}

# ----------------------------
# Subnetwork with secondary ranges for Pods and Services
# ----------------------------
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "${var.environment}-gke-subnet"
  ip_cidr_range = var.subnet_cidr    # Primary range for nodes
  region        = var.region
  network       = google_compute_network.gke_network.id

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

# ----------------------------
# GKE Cluster
# ----------------------------
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  deletion_protection = false
  networking_mode     = "VPC_NATIVE"

  network    = google_compute_network.gke_network.id
  subnetwork = google_compute_subnetwork.gke_subnet.id

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  ip_allocation_policy {
    cluster_secondary_range_name   = "pods"
    services_secondary_range_name  = "services"
  }

  release_channel {
    channel = "REGULAR"
  }

  enable_shielded_nodes = true
}

# ----------------------------
# Node Pool
# ----------------------------
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region

  node_count = var.node_count

  node_config {
    machine_type = var.node_type
    disk_size_gb = 20
    preemptible  = true

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.environment
    }

    tags = ["gke", var.environment]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}