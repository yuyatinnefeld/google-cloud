resource "google_compute_subnetwork" "subnet_0" {
  name          = "subnet-0"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-west1"
  network       = google_compute_network.main_net.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_network" "main_net" {
  name                    = "main-net"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "main-net-allow-ssh"
  network = google_compute_network.main_net.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["ssh-allow"]
  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_firewall" "allow_http" {
  name    = "main-net-allow-http"
  network = google_compute_network.main_net.id
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "main-net-allow-https"
  network = google_compute_network.main_net.id
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags   = ["https-server"]
  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main_net.id
}


