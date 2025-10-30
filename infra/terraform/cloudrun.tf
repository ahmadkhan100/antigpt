resource "google_cloud_run_service" "trigger_dev" {
  name     = "${local.name_prefix}-trigger"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.trigger_dev.email

      containers {
        image = var.container_image

        env {
          name = "NODE_ENV"
          value = var.environment
        }

        env {
          name = "LOG_BUCKET"
          value = google_storage_bucket.logs.name
        }
      }

      containers {
        name  = "metrics-sidecar"
        image = "gcr.io/cloudrun/hello"
      }

      container_concurrency = 80

      volumes {
        name = "tmp"
        empty_dir {}
      }

      timeout_seconds = 600
    }

    metadata {
      annotations = {
        "run.googleapis.com/ingress"                  = "internal-and-cloud-load-balancing"
        "run.googleapis.com/vpc-access-connector"    = google_vpc_access_connector.run_connector.name
        "run.googleapis.com/vpc-access-egress"       = "private-ranges-only"
        "autoscaling.knative.dev/minScale"           = "0"
        "autoscaling.knative.dev/maxScale"           = "5"
      }
      labels = local.common_labels
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  depends_on = [google_secret_manager_secret.managed]
}

resource "google_cloud_run_service_iam_member" "trigger_dev_invoker" {
  service  = google_cloud_run_service.trigger_dev.name
  location = google_cloud_run_service.trigger_dev.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.trigger_dev.email}"
}

