resource "google_service_account" "service_account_dssgcs" {
  account_id   = "dssgcs"
  display_name = "DSS GCS Service Account"
  description  = "DSS Service Account with access to Google Cloud Storage APIs"
}

resource "google_project_iam_member" "sa_dssgcs_iam_storage_admin" {
  project = local.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.service_account_dssgcs.email}"
}

### Account key
resource "google_service_account_key" "sa_gcs_key" {
  service_account_id = google_service_account.service_account_dssgcs.name
}
