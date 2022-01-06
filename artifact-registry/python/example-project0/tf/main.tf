terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.0.0"
    }
  }
}

provider "google-beta" {
  project     = var.project_id
  region      = var.region
}

resource "google_artifact_registry_repository" "my-repo" {
  provider = google-beta
  location = var.region
  repository_id = "my-python-repo"
  description = "example python repository"
  format = "PYTHON"
}