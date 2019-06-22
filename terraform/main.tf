resource "google_compute_instance" "instance-" {
  count        = "${var.instance_count}"
  name         = "instance-${count.index}"
  machine_type = "n1-standard-2"
  zone         = "europe-west1-b"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    sshKeys = "centos:${file(var.ssh_public_key_filepath)}"
  }
}