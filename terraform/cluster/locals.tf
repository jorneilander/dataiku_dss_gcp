locals {
  project = "candidate-emea-jeilander"
  region  = "europe-west4"
  zone    = "europe-west4-a"

  image_registry_url = "gcr.io/${local.project}"

  managed_domains = [
    "dataiku.azorion.com"
    ]

  dss_webui_port = 10000
}
