provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
