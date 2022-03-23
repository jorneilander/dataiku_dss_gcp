data "google_compute_default_service_account" "dssuser" {
}

resource "google_compute_instance_group" "dss" {
  name        = "dataikudss"
  description = "Dataiku DSS"
  zone        = local.zone
  network     = google_compute_network.vpc_network.id

  instances = [
    google_compute_instance.dss_instance.self_link
  ]

  lifecycle {
    create_before_destroy = true
  }
  named_port {
    name = "http"
    port = local.dss_webui_port
  }

}

resource "google_compute_backend_service" "dss_backend_service" {
  name      = "dss-backend-service"

  backend {
    group = google_compute_instance_group.dss.self_link
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }

  health_checks = [
    google_compute_health_check.https_proxy_health_check_dss.self_link
  ]

  load_balancing_scheme = "EXTERNAL_MANAGED"

}

resource "google_compute_disk" "dss_data_dir" {
  name = "dss-data-dir"
  zone = local.zone
  size = 100
  labels = {
    app = "dss"
  }
}

resource "google_compute_instance" "dss_instance" {
  name         = "dss-instance"
  machine_type = "c2-standard-8"
  tags = [
    "allow-ssh",
    "dss"
  ]
  labels = {
    app = "dss"
  }

  zone = local.zone

  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh_private_key.public_key_openssh}"
  }

  boot_disk {
    initialize_params {
      image = "almalinux-cloud/almalinux-8"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
      nat_ip = google_compute_address.dss_vm_external_ip.address
    }
  }

  allow_stopping_for_update = true

  service_account {
    email  = resource.google_service_account.dssuser_service_account.email
    scopes = ["cloud-platform"]
  }

  attached_disk {
    source      = google_compute_disk.dss_data_dir.id
    device_name = "dss_data_dir"
  }
}
