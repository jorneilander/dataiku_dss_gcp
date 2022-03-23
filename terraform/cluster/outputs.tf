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
  value = google_compute_global_forwarding_rule.https_proxy_forwarding_rule.ip_address
}
