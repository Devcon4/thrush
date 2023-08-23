
resource "google_project" "thrush_core" {
  name       = "dc-thrush-core"
  project_id = "dc-thrush-core"

  auto_create_network = false
  billing_account     = var.billingAccountId
}

resource "google_project_service" "iam-service_core" {
  project = google_project.thrush_core.project_id
  service = "iam.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "compute-service_core" {
  project = google_project.thrush_core.project_id
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "iap-service_core" {
  project = google_project.thrush_core.project_id
  service = "iap.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "container-service_core" {
  project = google_project.thrush_core.project_id
  service = "container.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "artifactregistry-service_core" {
  project = google_project.thrush_core.project_id
  service = "artifactregistry.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloudresourcemanager-service_core" {
  project = google_project.thrush_core.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}
resource "google_project_service" "sqladmin-service_core" {
  project = google_project.thrush_core.project_id
  service = "sqladmin.googleapis.com"

  disable_dependent_services = true
}

resource "google_service_account" "thrush_core_sa" {
  account_id   = "thrush-core-sa"
  project      = google_project.thrush_core.project_id
  display_name = "thrush-core-sa"
}

resource "google_project_iam_member" "thrush_core_project_owner_iam" {
  project = google_project.thrush_core.project_id
  member  = "serviceAccount:${google_service_account.thrush_core_sa.email}"
  role    = "roles/owner"

  depends_on = [
    google_service_account.thrush_core_sa
  ]
}