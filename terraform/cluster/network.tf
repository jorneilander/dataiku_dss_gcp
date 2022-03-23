# VPC

resource "google_compute_network" "vpc_network" {
  name                    = "dss-network"
  auto_create_subnetworks = "true"
}

# External IP-addresses

resource "google_compute_address" "dss_vm_external_ip" {
  name = "dss-vm-webui-public-address"
}

resource "google_compute_firewall" "firewall_allow_all_internal" {
  name        = "firewall-allow-all-internal"
  network     = google_compute_network.vpc_network.name

  allow {
    protocol = "all"
    ports    = []
  }

  source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_firewall" "firewall_allow_external" {
  name        = "firewall-allow-external-ssh"
  network     = google_compute_network.vpc_network.name
  target_tags = ["allow-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.public_access_cidrs
}

resource "google_compute_firewall" "firewall_allow_health_and_proxy" {
  name        = "firewall-allow-health-check-and-proxy"
  network     = google_compute_network.vpc_network.name
  target_tags = ["dss"]

  allow {
    protocol = "tcp"
    ports    = ["443","10000"]
  }

  source_ranges = ["130.211.0.0/22","35.191.0.0/16"]

}

resource "google_compute_firewall" "firewall_allow_home_dss_webui" {
  name        = "firewall-allow-home-dss-webui"
  network     = google_compute_network.vpc_network.name
  target_tags = ["dss"]

  allow {
    protocol = "tcp"
    ports    = ["10000"]
  }

  source_ranges = var.public_access_cidrs
}
