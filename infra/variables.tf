variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "node_count" {
  type = number
}

variable "node_type" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "pods_cidr" {
  type = string
}

variable "services_cidr" {
  type = string
}
