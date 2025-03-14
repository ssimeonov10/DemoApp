variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "oceanic-hook-451512-q8"
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west3"
}

variable "gcp_zone" {
  description = "GCP Zone"
  type        = string
  default     = "europe-west3-a"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "my-cluster"
}

variable "vpc_name" {
  description = "VPC Network Name"
  type        = string
  default     = "my-vpc"
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
  default     = "subnet-1"
}

variable "subnet_cidr" {
  description = "Subnet CIDR Range"
  type        = string
  default     = "10.0.0.0/20"
}

variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-standard-2"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 1
}