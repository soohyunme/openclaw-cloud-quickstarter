terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# 1. Network & Firewall
resource "google_compute_network" "vpc_network" {
  name                    = "${var.namespace}-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.namespace}-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.allowed_ssh_cidr]
  target_tags   = ["${var.namespace}-server"]
}

resource "google_compute_firewall" "allow_openclaw" {
  name    = "${var.namespace}-allow-openclaw"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["18789"]
  }

  source_ranges = [var.gateway_cidr]
  target_tags   = ["${var.namespace}-server"]
}

# 2. Compute Instance
resource "google_compute_instance" "openclaw_server" {
  name         = "${var.namespace}-server"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["${var.namespace}-server"]

  boot_disk {
    initialize_params {
      # Ubuntu 22.04 LTS
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    # SSH keys managed by OS Login (gcloud compute ssh)
    LLM_API_KEY      = var.llm_api_key
    OPENCLAW_MODEL   = var.openclaw_model
  }

  metadata_startup_script = file("${path.module}/scripts/setup.sh")

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    project    = "openclaw"
    managed_by = "terraform"
    namespace  = var.namespace
  }
}
