resource "google_compute_network" "main" {
  name = "main"
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "web" {
  name = "web"
  ip_cidr_range = "10.10.10.0/24"
  network = google_compute_network.main.id
  region = var.region

  secondary_ip_range = [
    {
      range_name    = "services"
      ip_cidr_range = "10.10.11.0/24"
    },
    {
      range_name    = "pods"
      ip_cidr_range = "10.1.0.0/20"
    }
  ]

  private_ip_google_access = true
}

resource "google_compute_address" "web" {
  name = "web"
  region = var.region
}

resource "google_compute_global_address" "traefik" {
  name         = "traefik"
  address_type = "EXTERNAL"
}

resource "google_compute_router" "web" {
  name    = "web"
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "web" {
  name                               = "web"
  router                             = google_compute_router.web.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.web.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.web.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  depends_on = [
    google_compute_address.web
  ]
}

resource "google_compute_firewall" "cert-manager-firewall" {
  name        = "cert-manager-firewall"
  network     = google_compute_network.main.id
  description = "Cert-manager gke private cluster fix; Allows pods to talk to eachother on port 9443 (used for webhooks)."

  allow {
    protocol = "tcp"
    ports    = ["9443"]
  }

  source_ranges = [var.gke_master_ipv4_cidr_block]
}