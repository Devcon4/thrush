resource "google_container_cluster" "thrush_prod" {
  provider   = google-beta
  name       = "dc-thrush-prod"
  location   = var.region
  network    = google_compute_network.main.name
  subnetwork = google_compute_subnetwork.web.id

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_ipv4_cidr_block
  }

  maintenance_policy {
    recurring_window {
      start_time = "2019-01-05T00:00:00Z"
      end_time   = "2019-01-07T23:59:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  release_channel {
    channel = "REGULAR"
  }
}

resource "google_container_node_pool" "web_pool" {
  name     = "web-pool"
  location = var.region
  cluster  = google_container_cluster.thrush_prod.name

  node_config {
    preemptible  = false
    machine_type = "e2-small"

    service_account = data.google_service_account.thrush_prod_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      "cyphers.dev/poolType" = "web"
    }
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }
}