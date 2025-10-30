resource "google_service_account" "trigger_dev" {
  account_id   = "${local.name_prefix}-trigger"
  display_name = "Trigger.dev Orchestrator"
}

resource "google_project_iam_member" "trigger_dev_roles" {
  for_each = toset([
    "roles/run.invoker",
    "roles/cloudscheduler.jobRunner",
    "roles/logging.logWriter",
    "roles/secretmanager.secretAccessor"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.trigger_dev.email}"
}

