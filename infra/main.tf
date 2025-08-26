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

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  deletion_protection = false

  # Networking
  networking_mode        = "VPC_NATIVE"
  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    # Now comes from variable so staging/prod don't conflict
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  ip_allocation_policy {}

  release_channel {
    channel = "REGULAR"
  }

  enable_shielded_nodes = true
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region

  node_count = var.node_count

  node_config {
    machine_type  = var.node_type
    disk_size_gb  = 20   # keep small for testing
    preemptible   = true
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
