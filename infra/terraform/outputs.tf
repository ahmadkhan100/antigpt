output "cloudsql_connection_name" {
  description = "Cloud SQL connection name for use in services"
  value       = google_sql_database_instance.primary.connection_name
}

output "cloudsql_private_ip" {
  description = "Private IP address of the Cloud SQL instance"
  value       = google_sql_database_instance.primary.private_ip_address
}

output "cloud_run_url" {
  description = "Base URL for Trigger.dev Cloud Run service"
  value       = google_cloud_run_service.trigger_dev.status[0].url
}

output "attachments_bucket" {
  description = "GCS bucket for attachments and exports"
  value       = google_storage_bucket.attachments.name
}

output "logs_bucket" {
  description = "GCS bucket for structured logs and artifacts"
  value       = google_storage_bucket.logs.name
}

output "secret_ids" {
  description = "Map of managed secret IDs"
  value       = { for key, secret in google_secret_manager_secret.managed : key => secret.secret_id }
}

output "trigger_dev_service_account" {
  description = "Email of the Trigger.dev service account"
  value       = google_service_account.trigger_dev.email
}

