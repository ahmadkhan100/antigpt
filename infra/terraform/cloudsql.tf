resource "google_service_account" "cloudsql" {
  account_id   = "${local.name_prefix}-cloudsql"
  display_name = "Cloud SQL automation account"
}

resource "google_sql_database_instance" "primary" {
  name             = "${local.name_prefix}-postgres"
  region           = var.cloudsql_region
  database_version = "POSTGRES_15"
  project          = var.project_id

  settings {
    tier = var.cloudsql_tier

    disk_autoresize = true
    disk_size       = var.cloudsql_disk_size
    disk_type       = "PD_SSD"

    availability_type = "REGIONAL"

    maintenance_window {
      day         = 7
      hour        = 3
      update_track = "stable"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.primary.id
      require_ssl     = true
    }

    insights_config {
      query_plans_per_minute       = 5
      query_string_length          = 1024
      record_application_tags      = true
      record_client_address        = true
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      backup_retention_settings {
        retained_backups = 14
      }
    }
  }

  deletion_protection = true

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "app" {
  name     = "app"
  instance = google_sql_database_instance.primary.name
}

resource "google_sql_user" "primary" {
  name     = var.cloudsql_primary_user
  instance = google_sql_database_instance.primary.name
  password = var.cloudsql_primary_password
}

resource "google_project_iam_member" "cloudsql_sa_roles" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/cloudsql.instanceUser"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloudsql.email}"
}

