resource "google_compute_network" "primary" {
  name                    = "${local.name_prefix}-vpc"
  auto_create_subnetworks = false
  description             = "Dedicated VPC for Social Update Agent"
}

resource "google_compute_subnetwork" "private" {
  name          = "${local.name_prefix}-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.primary.id
  purpose       = "PRIVATE"

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "connector" {
  name          = "${local.name_prefix}-connector-subnet"
  ip_cidr_range = "10.10.1.0/28"
  region        = var.region
  network       = google_compute_network.primary.id
  purpose       = "PRIVATE"

  private_ip_google_access = false
}

resource "google_compute_global_address" "private_service_range" {
  name          = "${local.name_prefix}-psa"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.primary.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.primary.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_range.name]
}

resource "google_vpc_access_connector" "run_connector" {
  name   = local.connector_id
  region = var.region
  subnet {
    name = google_compute_subnetwork.connector.name
  }
  min_throughput = 200
  max_throughput = 300
}

