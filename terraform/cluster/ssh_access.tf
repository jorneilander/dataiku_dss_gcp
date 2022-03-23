resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh_private_key.private_key_pem
  filename        = ".ssh/google_compute_engine"
  file_permission = "0600"
}

data "google_client_openid_userinfo" "me" {}
