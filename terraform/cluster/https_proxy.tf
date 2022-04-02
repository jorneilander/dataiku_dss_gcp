

# resource "google_compute_address" "dss_external_proxy_ipv4" {
#   name = "dss-https-proxy-address"
# }

resource "google_compute_target_https_proxy" "https_proxy_dss" {
  name             = "dss-https-proxy"
  url_map          = google_compute_url_map.all.id
  # ssl_policy       = google_compute_ssl_policy.compatible_ssl_policy.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.https_proxy_cert.self_link]

}

resource "google_compute_global_forwarding_rule" "https_proxy_forwarding_rule" {
  name = "dss-https-proxy"

  target              = google_compute_target_https_proxy.https_proxy_dss.self_link
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range = "443"

}

resource "random_id" "certificate" {
  byte_length = 4
  # prefix      = "issue6147-cert-"

  keepers = {
    domains = join(",", local.managed_domains)
  }

}


resource "google_compute_managed_ssl_certificate" "https_proxy_cert" {
  name = "dss-https-proxy-cert-${random_id.certificate.hex}"
  managed {
    domains = local.managed_domains
  }

  lifecycle { create_before_destroy = true }
}

resource "google_compute_health_check" "https_proxy_health_check_dss" {
  name        = "dss-health-check"
  description = "Health check via tcp"

  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  tcp_health_check {
    port = local.dss_webui_port
  }

}

resource "google_compute_url_map" "all" {
  name            = "dss-urlmap-${random_id.certificate.hex}"
  default_service = google_compute_backend_service.dss_backend_service.id

  lifecycle { create_before_destroy = true }

}

resource "google_compute_ssl_policy" "compatible_ssl_policy" {
  name    = "dss-https-proxy-ssl-policy-${random_id.certificate.hex}"
  profile = "COMPATIBLE"

}
