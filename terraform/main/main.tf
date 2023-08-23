terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.67.0"
    }
  }

  backend "gcs" {
    bucket = "dc-thrush-tf-bucket"
    prefix = "tfstate"
  }
}

provider "google" {
  project = var.prodProjectId
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.prodProjectId
  region  = var.region
  zone    = var.zone
}

data "google_project" "thrush_prod" {
  project_id = var.prodProjectId
}
data "google_project" "thrush_core" {
  project_id = var.coreProjectId
}
data "google_service_account" "thrush_prod_sa" {
  account_id = "thrush-prod-sa"
}