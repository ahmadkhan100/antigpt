# GCP Infrastructure (Terraform)

This module provisions the core GCP infrastructure required for the Social Update Agent platform:

- VPC network and connector for private service access
- Cloud SQL (PostgreSQL) instance with private IP and point-in-time recovery
- Cloud Run service that hosts Trigger.dev orchestrations
- Cloud Scheduler job (2-hour cadence) to invoke ingestion pipelines
- Cloud Storage buckets for attachments and long-term logs
- Secret Manager entries for sensitive API keys
- Service accounts with least-privilege IAM roles

## Prerequisites

1. Install Terraform `>= 1.6` and authenticate with Google Cloud (`gcloud auth application-default login`).
2. Enable required APIs in the target project:

   ```bash
   gcloud services enable \
     cloudresourcemanager.googleapis.com \
     compute.googleapis.com \
     vpcaccess.googleapis.com \
     servicenetworking.googleapis.com \
     sqladmin.googleapis.com \
     run.googleapis.com \
     cloudscheduler.googleapis.com \
     secretmanager.googleapis.com
   ```

3. Create a Terraform backend (e.g. GCS bucket) or use local state for experimentation.

## Usage

```hcl
module "social_update_agent" {
  source = "./infra/terraform"

  project_id                = "my-gcp-project"
  region                    = "us-central1"
  environment               = "staging"
  cloudsql_primary_password = var.cloudsql_primary_password
  container_image           = "us-docker.pkg.dev/my-project/trigger-dev/worker:latest"
  notification_email        = "ops@company.com"
  workos_redirect_uris      = ["https://app.company.com/auth/callback"]

  labels = {
    owner = "platform-team"
  }
}
```

Then run:

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Inputs Overview

- `project_id`: Target GCP project (required)
- `environment`: Label used in resource names (default `dev`)
- `cloudsql_primary_password`: Sensitive secret for the default DB user
- `container_image`: Trigger.dev container image to deploy to Cloud Run
- `workos_redirect_uris`: Optional metadata stored with secrets
- `secrets`: Map of Secret Manager entries; extend as needed

Refer to `variables.tf` for the complete input list.

## Outputs

- `cloudsql_connection_name`: Pass to application services for database connectivity
- `cloud_run_url`: Invoke to trigger orchestrations (Cloud Scheduler uses this)
- `secret_ids`: Map of Secret Manager secret IDs for reference

## Next Steps

- Connect Trigger.dev workflows to the Cloud Run service using the emitted service account.
- Grant WorkOS, Browserbase (Stagehand), and Trigger.dev integrations access to the relevant secrets via Secret Manager versions.
- Wire the Cloud SQL connection into application services (API, Electron sync daemon) using a Cloud SQL Proxy or private VPC connector.

