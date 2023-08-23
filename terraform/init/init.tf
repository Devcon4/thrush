terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.67.0"
    }
  }
}

provider "google" {
  region = var.region
  zone   = var.zone
}

provider "google-beta" {
  region = var.region
  zone   = var.zone
}

resource "google_storage_bucket" "terraform_bucket" {
  project  = google_project.thrush_core.project_id
  name     = "dc-thrush-tf-bucket"
  location = var.region

  storage_class = "STANDARD"
  force_destroy = true

  versioning {
    enabled = true
  }

  depends_on = [
    google_project.thrush_core,
  ]
}

resource "google_project_iam_member" "thrush_prod_owner_iam" {
  project = google_project.thrush_prod.project_id
  member  = "serviceAccount:${google_service_account.thrush_core_sa.email}"
  role    = "roles/owner"
}