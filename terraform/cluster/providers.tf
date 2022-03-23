

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.15.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
  }
}
provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

provider "tls" {
  // no config needed
}

provider "local" {
  // no config needed
}

provider "random" {
  // no config needed
}

resource "google_project_service" "cloud_resource_manager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}
