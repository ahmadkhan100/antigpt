variable "project_id" {
  description = "GCP project ID to deploy resources into"
  type        = string
}

variable "region" {
  description = "Primary region for regional resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Default zone for zonal resources"
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Deployment environment label (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cloudsql_region" {
  description = "Region for Cloud SQL instance"
  type        = string
  default     = "us-central1"
}

variable "cloudsql_primary_user" {
  description = "Primary database user name"
  type        = string
  default     = "app_admin"
}

variable "cloudsql_primary_password" {
  description = "Primary database user password"
  type        = string
  sensitive   = true
}

variable "cloudsql_tier" {
  description = "Cloud SQL machine tier"
  type        = string
  default     = "db-custom-2-7680"
}

variable "cloudsql_disk_size" {
  description = "Disk size for Cloud SQL instance (GB)"
  type        = number
  default     = 100
}

variable "container_image" {
  description = "Container image to deploy to Cloud Run for Trigger.dev orchestration"
  type        = string
  default     = "gcr.io/cloudrun/placeholder"
}

variable "notification_email" {
  description = "Email address to receive infrastructure alerts"
  type        = string
  default     = "ops@example.com"
}

variable "scheduler_service_account_email" {
  description = "Optional existing service account email for Cloud Scheduler; if empty a new one is created"
  type        = string
  default     = ""
}

variable "workos_redirect_uris" {
  description = "List of redirect URIs for WorkOS OAuth redirect (used in Secret Manager metadata)"
  type        = list(string)
  default     = []
}

variable "secrets" {
  description = "Map of secret IDs to descriptions for secrets required by the application"
  type        = map(string)
  default = {
    "openai_api_key"  = "OpenAI GPT-5 API key"
    "workos_api_key"  = "WorkOS API key"
    "stagehand_api"   = "Stagehand automation API token"
    "trigger_dev_key" = "Trigger.dev access token"
  }
}

variable "labels" {
  description = "Additional labels to apply to managed resources"
  type        = map(string)
  default     = {}
}

