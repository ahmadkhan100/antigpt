locals {
  name_prefix = "${var.environment}-social-agent"

  common_labels = merge({
    environment = var.environment,
    managed_by  = "terraform",
    app         = "social-update-agent"
  }, var.labels)
}

