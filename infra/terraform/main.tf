resource "google_project_service" "enabled_services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com"
  ])

  project = var.gcp_project_id
  service = each.key
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
}

# Create GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name                     = var.cluster_name
  location                 = var.gcp_zone
  network                  = google_compute_network.vpc.id
  subnetwork               = google_compute_subnetwork.subnet.id
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.gcp_project_id}.svc.id.goog"
  }
}

# Create GKE Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.gcp_zone
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
resource "helm_release" "postgresql" {
  name       = "postgres"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = var.helm_chart_version

  create_namespace = true

  values = [file("${path.module}/values.yaml")]

  set {
    name  = "auth.postgresPassword"
    value = var.postgres_password
  }
}