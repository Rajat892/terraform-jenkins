resource "google_compute_instance" "vm" {
  name         = "${var.project_id}-${var.environment}-vm"
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2504-plucky-amd64-v20250430"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {} # optional ephemeral public IP
  }

  labels = {
    environment = var.environment
    project     = var.project_id
  }

  tags = ["${var.environment}-vm"]

  service_account {
    email  = "terraform-sa@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}
