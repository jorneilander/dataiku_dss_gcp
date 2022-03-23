resource "google_container_cluster" "dss_cluster" {
  name     = "dss-gke-cluster"
  location = local.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network = google_compute_network.vpc_network.id
}

resource "google_container_node_pool" "dss_cluster_preemptible_nodes" {
  name       = "dss-gke-node-pool"
  location   = local.zone
  cluster    = google_container_cluster.dss_cluster.name
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "e2-standard-8"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.dssuser_service_account.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_storage_bucket" "dss_storage_bucket" {
  name          = "dss-storage-bucket"
  location      = "EU"
  force_destroy = true
}

resource "google_container_registry" "dss_image_registry" {
  project  = local.project
  location = "EU"
}
