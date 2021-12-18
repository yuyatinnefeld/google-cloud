resource "google_sql_database_instance" "private_db_instance" {
  name             = "private-db-instance"
  database_version = "POSTGRES_13"
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main_net.id
    }
  }
  deletion_protection = false
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main_net.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database" "frontend_private_db" {
  name     = "frontend-db"
  instance = google_sql_database_instance.private_db_instance.name
}

resource "google_sql_user" "postgres_private_user" {
  name     = "postgres"
  instance = google_sql_database_instance.private_db_instance.name
  password = var.postgres_pass
  deletion_protection = false
}
