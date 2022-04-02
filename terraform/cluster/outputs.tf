output "public_ip" {
  description = "Public IP-address of VPC"
  value = google_compute_address.dss_vm_external_ip.address
}

output "dss_internal_ip" {
  value = google_compute_instance.dss_instance.network_interface.0.network_ip
}

output "sa_google_storage_private_key" {
  description = "Private key service account with access to Google Storage APIs"
  value = google_service_account_key.sa_gcs_key.private_key
  sensitive = true
}

output "image_registry_url" {
  description = "URL for the container image registry in the GCP Project"
  value = "gcr.io/${local.project}"
}

output "gke_dss_cluster_name" {
  description = "Name of the GKE cluster created for DSS"
  value = google_container_cluster.dss_cluster.name
}

output "gcp_zone" {
  description = "GCP Zone used for project"
  value = local.zone
}

output "https_proxy_ip" {
  description = "Public IP-address of the HTTPS-proxy"
  value = google_compute_global_forwarding_rule.https_proxy_forwarding_rule.ip_address
}

output "dss_username" {
  description = "Username of DSS instance service account"
  value = google_service_account.dssuser_service_account.account_id
  # value = google_compute_instance.dss_instance.service_account
}

output "gcp_project_id" {
  description = "GCP Project ID"
  value = local.project
}

output "gcs_bucket" {
  description = "GCS Storage bucket"
  value = google_storage_bucket.dss_storage_bucket.name
}

output "private_key_file" {
  description = "GCP user service account's private SSH-key file path"
  value = "${path.cwd}/${local_file.ssh_private_key_pem.filename}"
}
