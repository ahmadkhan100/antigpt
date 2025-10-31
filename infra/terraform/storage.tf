resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "attachments" {
  name                        = "${local.name_prefix}-attachments-${random_id.bucket_suffix.hex}"
  location                    = var.region
  force_destroy               = false
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }

  labels = local.common_labels
}

resource "google_storage_bucket" "logs" {
  name                        = "${local.name_prefix}-logs-${random_id.bucket_suffix.hex}"
  location                    = var.region
  force_destroy               = false
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age = 30
    }
  }

  labels = local.common_labels
}

