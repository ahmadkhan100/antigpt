resource "google_secret_manager_secret" "managed" {
  for_each = var.secrets

  secret_id = "${local.name_prefix}-${each.key}"

  replication {
    automatic = true
  }

  labels = local.common_labels
}

resource "google_secret_manager_secret_iam_member" "trigger_dev_access" {
  for_each = google_secret_manager_secret.managed

  project   = var.project_id
  secret_id = each.value.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.trigger_dev.email}"
}

