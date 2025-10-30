locals {
  scheduler_sa_email = var.scheduler_service_account_email != ""
    ? var.scheduler_service_account_email
    : google_service_account.scheduler[0].email
}

resource "google_service_account" "scheduler" {
  count        = var.scheduler_service_account_email == "" ? 1 : 0
  account_id   = "${local.name_prefix}-scheduler"
  display_name = "Cloud Scheduler Agent"
}

resource "google_project_iam_member" "scheduler_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${local.scheduler_sa_email}"
}

resource "google_cloud_scheduler_job" "ingest" {
  name        = "${local.name_prefix}-ingestion"
  description = "Triggers ingestion pipeline every 2 hours"
  schedule    = "0 */2 * * *"
  time_zone   = "Etc/UTC"

  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = google_cloud_run_service.trigger_dev.status[0].url

    oidc_token {
      service_account_email = local.scheduler_sa_email
      audience              = google_cloud_run_service.trigger_dev.status[0].url
    }

    headers = {
      "Content-Type" = "application/json"
    }

    body = base64encode(jsonencode({
      job = "ingest",
      schedule = "2h"
    }))
  }

  retry_config {
    retry_count            = 3
    max_retry_duration     = "600s"
    min_backoff_duration   = "10s"
    max_backoff_duration   = "60s"
    max_doublings          = 3
  }

  depends_on = [google_project_iam_member.scheduler_run_invoker]
}

