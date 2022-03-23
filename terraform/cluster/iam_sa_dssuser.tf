resource "google_service_account" "dssuser_service_account" {
  account_id   = "dssuser"
  display_name = "DSS Service Account"
  description  = "DSS Service Account"
}

resource "google_project_iam_member" "container_admin" {
  project = local.project
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.dssuser_service_account.email}"
}

resource "google_project_iam_member" "editor" {
  project = local.project
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.dssuser_service_account.email}"
}

resource "google_project_iam_member" "compute_instance_admin" {
  project = local.project
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.dssuser_service_account.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = local.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.dssuser_service_account.email}"
}

resource "google_project_iam_member" "sa_dssuser_iam_storage_admin" {
  project = local.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.dssuser_service_account.email}"
}
