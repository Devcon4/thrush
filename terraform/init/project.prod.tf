
resource "google_project" "thrush_prod" {
  name       = "dc-thrush-prod"
  project_id = "dc-thrush-prod"

  auto_create_network = false
  billing_account     = var.billingAccountId
}

resource "google_project_service" "iam-service_prod" {
  project = google_project.thrush_prod.project_id
  service = "iam.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "compute-service_prod" {
  project = google_project.thrush_prod.project_id
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "iap-service_prod" {
  project = google_project.thrush_prod.project_id
  service = "iap.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "container-service_prod" {
  project = google_project.thrush_prod.project_id
  service = "container.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "artifactregistry-service_prod" {
  project = google_project.thrush_prod.project_id
  service = "artifactregistry.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloudresourcemanager-service_prod" {
  project = google_project.thrush_prod.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}
resource "google_project_service" "sqladmin-service_prod" {
  project = google_project.thrush_prod.project_id
  service = "sqladmin.googleapis.com"

  disable_dependent_services = true
}

resource "google_service_account" "thrush_prod_sa" {
  account_id   = "thrush-prod-sa"
  project      = google_project.thrush_prod.project_id
  display_name = "thrush-prod-sa"
}

resource "google_project_iam_member" "thrush_prod_project_owner_iam" {
  project = google_project.thrush_prod.project_id
  member  = "serviceAccount:${google_service_account.thrush_prod_sa.email}"
  role    = "roles/owner"

  depends_on = [
    google_service_account.thrush_prod_sa
  ]
}