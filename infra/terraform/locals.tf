locals {
  name_prefix = "${var.environment}-social-agent"
  connector_id = regexall("^[a-z][-a-z0-9]{0,22}", "${local.name_prefix}-conn")[0]

  common_labels = merge({
    environment = var.environment,
    managed_by  = "terraform",
    app         = "social-update-agent"
  }, var.labels)
}

