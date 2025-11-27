resource "google_compute_instance" "vm" {
  name         = "${var.environment}-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2504-plucky-amd64-v20250430"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
  }
}
